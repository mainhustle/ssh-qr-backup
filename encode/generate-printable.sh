#!/bin/bash

# Ordner mit den QR-Code-Bildern
QR_DIR="./qrcodes"
OUTPUT_FILE="./printable_qrcodes.html"
CURRENT_DATETIME=$(date '+%Y-%m-%d %H:%M:%S')

# HTML-Datei initialisieren
echo "<html><head><title>Printable QR Codes - $CURRENT_DATETIME</title>" > "$OUTPUT_FILE"
echo "<style>
    body { font-family: Arial, sans-serif; text-align: center; }
    .qr-container { display: flex; flex-wrap: wrap; justify-content: center; page-break-after: always; }
    .qr-item { width: 100%; padding: 20px; box-sizing: border-box; page-break-after: always; }
    img { width: 100%; height: auto; }
</style>" >> "$OUTPUT_FILE"
echo "</head><body>" >> "$OUTPUT_FILE"
echo "<h1>Printable QR Codes</h1>" >> "$OUTPUT_FILE"
echo "<h2>Generated on: $CURRENT_DATETIME</h2>" >> "$OUTPUT_FILE"
echo "<strong>More Information: https://github.com/mainhustle/ssh-qr-backup</strong>" >> "$OUTPUT_FILE"

echo "Erstelle druckbare Datei mit QR-Codes..."

echo "<div class='qr-container'>" >> "$OUTPUT_FILE"

# QR-Codes in HTML-Dokument einfügen
count=0
for qr in "$QR_DIR"/*.png; do
    if [[ -f "$qr" ]]; then
        FILENAME=$(basename "$qr")
        echo "<div class='qr-item'>" >> "$OUTPUT_FILE"
        echo "<h3>$FILENAME</h3>" >> "$OUTPUT_FILE"
        echo "<img src='$qr' alt='$FILENAME' />" >> "$OUTPUT_FILE"
        echo "</div>" >> "$OUTPUT_FILE"
        ((count++))
        if (( count % 2 == 0 )); then
            echo "</div><div class='qr-container'>" >> "$OUTPUT_FILE"
        fi
    fi
done

echo "</div>" >> "$OUTPUT_FILE"
echo "</body></html>" >> "$OUTPUT_FILE"

echo "Druckbare Datei wurde erstellt: $OUTPUT_FILE"
