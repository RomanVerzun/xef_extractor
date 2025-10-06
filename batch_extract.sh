#!/bin/bash
# Скрипт для масової екстракції всіх XEF файлів у папці

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTRACTOR="$SCRIPT_DIR/xef_extractor.py"

echo "=========================================="
echo "  Масова екстракція XEF файлів"
echo "=========================================="

if [ ! -f "$EXTRACTOR" ]; then
    echo "❌ Помилка: xef_extractor.py не знайдено!"
    exit 1
fi

# Знайти всі XEF файли
XEF_FILES=("$SCRIPT_DIR"/*.xef "$SCRIPT_DIR"/*.XEF)
COUNT=0

for xef_file in "${XEF_FILES[@]}"; do
    if [ -f "$xef_file" ]; then
        echo ""
        echo "📄 Обробка: $(basename "$xef_file")"
        python3 "$EXTRACTOR" "$xef_file"
        ((COUNT++))
    fi
done

echo ""
echo "=========================================="
echo "✅ Оброблено файлів: $COUNT"
echo "=========================================="

