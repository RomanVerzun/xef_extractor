#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
XEF Code Extractor - Витягує тільки код програм з Unity Pro/Control Expert файлів
Виключає технічні деталі для зручного контролю версій
"""

import xml.etree.ElementTree as ET
import sys
import os
from pathlib import Path
from datetime import datetime


class XEFExtractor:
    """Екстрактор коду з XEF файлів"""
    
    def __init__(self, xef_file_path):
        self.xef_file_path = Path(xef_file_path)
        self.tree = None
        self.root = None
        self.extracted_data = {
            'project_info': {},
            'fb_sources': [],      # Функціональні блоки
            'ddt_sources': [],     # Типи даних (DDT)
            'ef_sources': [],      # Зовнішні функції
            'dfb_sources': [],     # DFB блоки
            'programs': [],        # Програми
            'variables': {},       # Змінні проекту
        }
        
    def parse(self):
        """Парсинг XEF файлу"""
        try:
            self.tree = ET.parse(self.xef_file_path)
            self.root = self.tree.getroot()
            print(f"✓ Файл успішно прочитано: {self.xef_file_path.name}")
            return True
        except Exception as e:
            print(f"✗ Помилка читання файлу: {e}")
            return False
    
    def extract_project_info(self):
        """Витягти інформацію про проект (без технічних деталей)"""
        content_header = self.root.find('contentHeader')
        if content_header is not None:
            self.extracted_data['project_info'] = {
                'name': content_header.get('name', 'Unknown'),
                'version': content_header.get('version', '0.0.0'),
            }
    
    def extract_fb_sources(self):
        """Витягти функціональні блоки (FBSource)"""
        for fb_source in self.root.findall('FBSource'):
            fb_data = {
                'name': fb_source.get('nameOfFBType'),
                'version': fb_source.get('version'),
                'comment': self._get_text(fb_source.find('comment')),
                'input_parameters': [],
                'output_parameters': [],
                'inout_parameters': [],
                'private_variables': [],
                'public_variables': [],
                'programs': []
            }
            
            # Вхідні параметри
            input_params = fb_source.find('inputParameters')
            if input_params is not None:
                fb_data['input_parameters'] = self._extract_variables(input_params)
            
            # Вихідні параметри
            output_params = fb_source.find('outputParameters')
            if output_params is not None:
                fb_data['output_parameters'] = self._extract_variables(output_params)
            
            # InOut параметри
            inout_params = fb_source.find('inOutParameters')
            if inout_params is not None:
                fb_data['inout_parameters'] = self._extract_variables(inout_params)
            
            # Приватні змінні
            private_vars = fb_source.find('privateLocalVariables')
            if private_vars is not None:
                fb_data['private_variables'] = self._extract_variables(private_vars)
            
            # Публічні змінні
            public_vars = fb_source.find('publicLocalVariables')
            if public_vars is not None:
                fb_data['public_variables'] = self._extract_variables(public_vars)
            
            # Програми FB
            for fb_program in fb_source.findall('FBProgram'):
                program_data = {
                    'name': fb_program.get('name'),
                    'code': ''
                }
                
                # ST код
                st_source = fb_program.find('STSource')
                if st_source is not None:
                    program_data['code'] = self._get_text(st_source)
                    program_data['language'] = 'ST'
                
                # SFC код
                sfc_source = fb_program.find('SFCSource')
                if sfc_source is not None:
                    program_data['code'] = self._extract_sfc(sfc_source)
                    program_data['language'] = 'SFC'
                
                fb_data['programs'].append(program_data)
            
            self.extracted_data['fb_sources'].append(fb_data)
    
    def extract_ddt_sources(self):
        """Витягти типи даних (DDTSource)"""
        for ddt_source in self.root.findall('DDTSource'):
            ddt_data = {
                'name': ddt_source.get('DDTName'),
                'version': ddt_source.get('version'),
                'comment': self._get_text(ddt_source.find('comment')),
                'structure': []
            }
            
            # Структура DDT
            structure = ddt_source.find('structure')
            if structure is not None:
                ddt_data['structure'] = self._extract_variables(structure)
            
            self.extracted_data['ddt_sources'].append(ddt_data)
    
    def extract_ef_sources(self):
        """Витягти зовнішні функції (EFSource)"""
        for ef_source in self.root.findall('EFSource'):
            ef_data = {
                'name': ef_source.get('nameOfEFType'),
                'version': ef_source.get('version'),
                'comment': self._get_text(ef_source.find('comment')),
                'input_parameters': [],
                'output_parameters': [],
            }
            
            # Шукаємо в ExternalToolsOnly
            external_tools = ef_source.find('ExternalToolsOnly')
            if external_tools is not None:
                input_params = external_tools.find('inputParameters')
                if input_params is not None:
                    ef_data['input_parameters'] = self._extract_variables(input_params)
                
                output_params = external_tools.find('outputParameters')
                if output_params is not None:
                    ef_data['output_parameters'] = self._extract_variables(output_params)
            
            self.extracted_data['ef_sources'].append(ef_data)
    
    def extract_dfb_sources(self):
        """Витягти DFB блоки (DFBSource)"""
        for dfb_source in self.root.findall('DFBSource'):
            dfb_data = {
                'name': dfb_source.get('nameOfDFBType'),
                'version': dfb_source.get('version'),
                'comment': self._get_text(dfb_source.find('comment')),
                'code': ''
            }
            
            # ST код
            st_source = dfb_source.find('STSource')
            if st_source is not None:
                dfb_data['code'] = self._get_text(st_source)
                dfb_data['language'] = 'ST'
            
            self.extracted_data['dfb_sources'].append(dfb_data)
    
    def extract_programs(self):
        """Витягти основні програми"""
        for program in self.root.findall('program'):
            # Шукаємо identProgram для отримання імені та інфо
            ident_program = program.find('identProgram')
            if ident_program is not None:
                prog_data = {
                    'name': ident_program.get('name'),
                    'type': ident_program.get('type', ''),
                    'task': ident_program.get('task', ''),
                    'section_order': ident_program.get('SectionOrder', ''),
                    'comment': self._get_text(program.find('comment')),
                    'code': ''
                }
            else:
                # Fallback якщо немає identProgram
                prog_data = {
                    'name': program.get('name', 'Unknown'),
                    'task': program.get('task', ''),
                    'comment': self._get_text(program.find('comment')),
                    'code': ''
                }
            
            # ST код
            st_source = program.find('STSource')
            if st_source is not None:
                prog_data['code'] = self._get_text(st_source)
                prog_data['language'] = 'ST'
            
            # SFC код
            sfc_source = program.find('SFCSource')
            if sfc_source is not None:
                prog_data['code'] = self._extract_sfc(sfc_source)
                prog_data['language'] = 'SFC'
            
            # LD код
            ld_source = program.find('LDSource')
            if ld_source is not None:
                prog_data['code'] = "<!-- LD Ladder Diagram -->\n"
                prog_data['language'] = 'LD'
            
            if prog_data['name']:  # Додати тільки якщо є ім'я
                self.extracted_data['programs'].append(prog_data)
    
    def _extract_variables(self, parent_element):
        """Витягти змінні з елемента"""
        variables = []
        for var in parent_element.findall('variables'):
            var_data = {
                'name': var.get('name'),
                'type': var.get('typeName'),
                'comment': self._get_text(var.find('comment')),
                'initial_value': var.get('topologicalAddress', '')
            }
            variables.append(var_data)
        return variables
    
    def _extract_sfc(self, sfc_element):
        """Витягти SFC код (спрощено)"""
        return "<!-- SFC Structure -->\n"
    
    def _get_text(self, element):
        """Отримати текст з елемента"""
        if element is not None and element.text:
            return element.text.strip()
        return ""
    
    def extract_all(self):
        """Витягти всі дані"""
        print("\n🔍 Початок екстракції...")
        self.extract_project_info()
        print(f"  ✓ Інформація про проект")
        
        self.extract_fb_sources()
        print(f"  ✓ Функціональні блоки: {len(self.extracted_data['fb_sources'])}")
        
        self.extract_ddt_sources()
        print(f"  ✓ Типи даних (DDT): {len(self.extracted_data['ddt_sources'])}")
        
        self.extract_ef_sources()
        print(f"  ✓ Зовнішні функції (EF): {len(self.extracted_data['ef_sources'])}")
        
        self.extract_dfb_sources()
        print(f"  ✓ DFB блоки: {len(self.extracted_data['dfb_sources'])}")
        
        self.extract_programs()
        print(f"  ✓ Програми: {len(self.extracted_data['programs'])}")
    
    def save_to_files(self, output_dir):
        """Зберегти витягнуті дані у структуру файлів"""
        output_path = Path(output_dir)
        output_path.mkdir(parents=True, exist_ok=True)
        
        print(f"\n📁 Збереження у: {output_path}")
        
        # Створити структуру каталогів
        (output_path / 'FunctionBlocks').mkdir(exist_ok=True)
        (output_path / 'DataTypes').mkdir(exist_ok=True)
        (output_path / 'Functions').mkdir(exist_ok=True)
        (output_path / 'Programs').mkdir(exist_ok=True)
        
        # Зберегти інформацію про проект
        self._save_project_info(output_path)
        
        # Зберегти функціональні блоки
        for fb in self.extracted_data['fb_sources']:
            self._save_fb(fb, output_path / 'FunctionBlocks')
        
        # Зберегти типи даних
        for ddt in self.extracted_data['ddt_sources']:
            self._save_ddt(ddt, output_path / 'DataTypes')
        
        # Зберегти зовнішні функції
        for ef in self.extracted_data['ef_sources']:
            self._save_ef(ef, output_path / 'Functions')
        
        # Зберегти DFB
        for dfb in self.extracted_data['dfb_sources']:
            self._save_dfb(dfb, output_path / 'FunctionBlocks')
        
        # Зберегти програми
        for prog in self.extracted_data['programs']:
            self._save_program(prog, output_path / 'Programs')
        
        print(f"\n✅ Екстракція завершена!")
    
    def _save_project_info(self, output_path):
        """Зберегти інформацію про проект"""
        info = self.extracted_data['project_info']
        content = f"""(*
===========================================
PROJECT: {info.get('name', 'Unknown')}
VERSION: {info.get('version', '0.0.0')}
EXTRACTED: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
===========================================
*)
"""
        with open(output_path / 'PROJECT_INFO.txt', 'w', encoding='utf-8') as f:
            f.write(content)
    
    def _save_fb(self, fb, output_path):
        """Зберегти функціональний блок"""
        if not fb['name']:
            return
        
        filename = f"{fb['name']}.st"
        content = []
        
        content.append(f"(* ======================================== *)")
        content.append(f"(* FUNCTION BLOCK: {fb['name']} *)")
        content.append(f"(* VERSION: {fb['version']} *)")
        if fb['comment']:
            content.append(f"(* {fb['comment']} *)")
        content.append(f"(* ======================================== *)\n")
        
        # Вхідні параметри
        if fb['input_parameters']:
            content.append("(* INPUT PARAMETERS *)")
            for var in fb['input_parameters']:
                comment = f" (* {var['comment']} *)" if var['comment'] else ""
                content.append(f"  {var['name']} : {var['type']};{comment}")
            content.append("")
        
        # Вихідні параметри
        if fb['output_parameters']:
            content.append("(* OUTPUT PARAMETERS *)")
            for var in fb['output_parameters']:
                comment = f" (* {var['comment']} *)" if var['comment'] else ""
                content.append(f"  {var['name']} : {var['type']};{comment}")
            content.append("")
        
        # InOut параметри
        if fb['inout_parameters']:
            content.append("(* INOUT PARAMETERS *)")
            for var in fb['inout_parameters']:
                comment = f" (* {var['comment']} *)" if var['comment'] else ""
                content.append(f"  {var['name']} : {var['type']};{comment}")
            content.append("")
        
        # Приватні змінні
        if fb['private_variables']:
            content.append("(* PRIVATE VARIABLES *)")
            for var in fb['private_variables']:
                comment = f" (* {var['comment']} *)" if var['comment'] else ""
                content.append(f"  {var['name']} : {var['type']};{comment}")
            content.append("")
        
        # Публічні змінні
        if fb['public_variables']:
            content.append("(* PUBLIC VARIABLES *)")
            for var in fb['public_variables']:
                comment = f" (* {var['comment']} *)" if var['comment'] else ""
                content.append(f"  {var['name']} : {var['type']};{comment}")
            content.append("")
        
        # Програми
        for program in fb['programs']:
            content.append(f"\n(* -------- PROGRAM: {program['name']} -------- *)")
            if program['code']:
                content.append(program['code'])
            content.append("")
        
        with open(output_path / filename, 'w', encoding='utf-8') as f:
            f.write('\n'.join(content))
    
    def _save_ddt(self, ddt, output_path):
        """Зберегти тип даних"""
        if not ddt['name']:
            return
        
        filename = f"{ddt['name']}.ddt"
        content = []
        
        content.append(f"(* ======================================== *)")
        content.append(f"(* DATA TYPE: {ddt['name']} *)")
        content.append(f"(* VERSION: {ddt['version']} *)")
        if ddt['comment']:
            content.append(f"(* {ddt['comment']} *)")
        content.append(f"(* ======================================== *)\n")
        
        content.append(f"TYPE {ddt['name']} :")
        content.append("STRUCT")
        
        for var in ddt['structure']:
            comment = f" (* {var['comment']} *)" if var['comment'] else ""
            content.append(f"  {var['name']} : {var['type']};{comment}")
        
        content.append("END_STRUCT;")
        content.append("END_TYPE")
        
        with open(output_path / filename, 'w', encoding='utf-8') as f:
            f.write('\n'.join(content))
    
    def _save_ef(self, ef, output_path):
        """Зберегти зовнішню функцію"""
        if not ef['name']:
            return
        
        filename = f"{ef['name']}.ef"
        content = []
        
        content.append(f"(* ======================================== *)")
        content.append(f"(* EXTERNAL FUNCTION: {ef['name']} *)")
        content.append(f"(* VERSION: {ef['version']} *)")
        if ef['comment']:
            content.append(f"(* {ef['comment']} *)")
        content.append(f"(* ======================================== *)\n")
        
        # Вхідні параметри
        if ef['input_parameters']:
            content.append("(* INPUT PARAMETERS *)")
            for var in ef['input_parameters']:
                comment = f" (* {var['comment']} *)" if var['comment'] else ""
                content.append(f"  {var['name']} : {var['type']};{comment}")
            content.append("")
        
        # Вихідні параметри
        if ef['output_parameters']:
            content.append("(* OUTPUT PARAMETERS *)")
            for var in ef['output_parameters']:
                comment = f" (* {var['comment']} *)" if var['comment'] else ""
                content.append(f"  {var['name']} : {var['type']};{comment}")
            content.append("")
        
        with open(output_path / filename, 'w', encoding='utf-8') as f:
            f.write('\n'.join(content))
    
    def _save_dfb(self, dfb, output_path):
        """Зберегти DFB блок"""
        if not dfb['name']:
            return
        
        filename = f"{dfb['name']}_DFB.st"
        content = []
        
        content.append(f"(* ======================================== *)")
        content.append(f"(* DFB: {dfb['name']} *)")
        content.append(f"(* VERSION: {dfb['version']} *)")
        if dfb['comment']:
            content.append(f"(* {dfb['comment']} *)")
        content.append(f"(* ======================================== *)\n")
        
        if dfb['code']:
            content.append(dfb['code'])
        
        with open(output_path / filename, 'w', encoding='utf-8') as f:
            f.write('\n'.join(content))
    
    def _save_program(self, prog, output_path):
        """Зберегти програму"""
        if not prog['name']:
            return
        
        filename = f"{prog['name']}.st"
        content = []
        
        content.append(f"(* ======================================== *)")
        content.append(f"(* PROGRAM: {prog['name']} *)")
        if prog.get('type'):
            content.append(f"(* TYPE: {prog['type']} *)")
        if prog.get('task'):
            content.append(f"(* TASK: {prog['task']} *)")
        if prog.get('section_order'):
            content.append(f"(* SECTION ORDER: {prog['section_order']} *)")
        if prog.get('comment'):
            content.append(f"(* {prog['comment']} *)")
        content.append(f"(* ======================================== *)\n")
        
        if prog.get('code'):
            content.append(prog['code'])
        
        with open(output_path / filename, 'w', encoding='utf-8') as f:
            f.write('\n'.join(content))


def main():
    """Головна функція"""
    print("=" * 60)
    print("  XEF CODE EXTRACTOR - Екстрактор коду Unity Pro/Control Expert")
    print("=" * 60)
    
    if len(sys.argv) < 2:
        print("\nВикористання:")
        print(f"  python {sys.argv[0]} <шлях_до_XEF_файлу> [вихідна_папка]")
        print("\nПриклад:")
        print(f"  python {sys.argv[0]} unitpro.xef")
        print(f"  python {sys.argv[0]} unitpro.xef extracted_code")
        sys.exit(1)
    
    xef_file = sys.argv[1]
    
    if not os.path.exists(xef_file):
        print(f"\n✗ Файл не знайдено: {xef_file}")
        sys.exit(1)
    
    # Визначити вихідну папку
    if len(sys.argv) >= 3:
        output_dir = sys.argv[2]
    else:
        base_name = Path(xef_file).stem
        output_dir = f"{base_name}_extracted"
    
    # Створити екстрактор
    extractor = XEFExtractor(xef_file)
    
    # Парсинг
    if not extractor.parse():
        sys.exit(1)
    
    # Екстракція
    extractor.extract_all()
    
    # Збереження
    extractor.save_to_files(output_dir)
    
    print(f"\n📂 Результат збережено у: {Path(output_dir).absolute()}")
    print("\n" + "=" * 60)


if __name__ == '__main__':
    main()

