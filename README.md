# XEF Code Extractor

Витягує код з Unity Pro/Control Expert XEF файлів для контролю версій у Git.

## Проблема

XEF файли генерують сотні змін при мінімальних правках через timestamps, GUID'и та checksums.

## Рішення

Екстрактор витягує тільки код (FB, DDT, EF, Programs) без технічних деталей.

## Підготовка XEF файлу

Проекти зберігаються у форматі ZEF (архів). Витягніть проект:

```bash
unzip NECS2.ZEF -d NECS2
```

Знайдіть файл `unitpro.xef` у каталозі проекту та скопіюйте його у папку зі скриптом:

```bash
cp NECS2/unitpro.xef ./unitpro.xef
```

## Використання

### Базове

```bash
# Один файл
python3 xef_extractor.py "project.xef"

# Всі XEF у папці
./batch_extract.sh
```

### Результат

```text
unitpro_extracted/
├── FunctionBlocks/    # FB блоки (.st)
├── DataTypes/         # DDT типи (.ddt)
├── Functions/         # EF функції (.ef)
├── Programs/          # Програми (.st)
└── PROJECT_INFO.txt
```

## Git інтеграція

Скопіюйте витягнутий код у ваш Git репозиторій проекту:

```bash
# Витягти код
python3 xef_extractor.py "unitpro.xef"

# Скопіювати у Git репозиторій
cp -r unitpro_extracted/* /path/to/your/project-repo/

# Закомітити у вашому репозиторії
cd /path/to/your/project-repo/
git add .
git commit -m "Update PLC code"
git push
```

## Що витягується

| Так | Ні |
|-----|-----|
| ST/SFC/LD код | IOConf |
| FB блоки | GUID |
| DDT типи | Checksums |
| EF функції | Timestamps |
| Програми | HexValues |
| Змінні | Графіка HMI |
| Коментарі | |


## Вимоги

- Python 3.6+
- Жодних додаткових бібліотек

## FAQ

**Q: Чи можна відновити XEF з витягнутого коду?**  
A: Ні, витягується тільки логіка програми.

**Q: Працює з Control Expert 15.x/14.x?**  
A: Так, формат XEF сумісний.

**Q: Підтримка Windows?**  
A: Так, Python крос-платформний.

---

**Версія**: 1.0  
**Автор**: Created for Unity Pro/Control Expert version control
