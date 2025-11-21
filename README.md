# XEF Code Extractor

Витягує код з Unity Pro/Control Expert XEF файлів для контролю версій у Git.

## Проблема

XEF файли генерують сотні змін при мінімальних правках через timestamps, GUID'и та checksums.

## Рішення

Екстрактор витягує тільки код (FB, DDT, EF, Programs) без технічних деталей.

## Використання

### Базове

```bash
# Один файл
python3 xef_extractor.py "project.xef"

# Всі XEF у папці
./batch_extract.sh



### Результат

```
project_extracted/
├── FunctionBlocks/    # FB блоки (.st)
├── DataTypes/         # DDT типи (.ddt)
├── Functions/         # EF функції (.ef)
├── Programs/          # Програми (.st)
└── PROJECT_INFO.txt
```

## Git інтеграція


### Вручну

```bash
python3 xef_extractor.py "project.xef"
git add project_extracted/
git commit -m "зміни"
```

### Варіант 3: Тільки витягнутий код

```bash
# .gitignore
*.xef

# Зберігати тільки код
git add project_extracted/
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
