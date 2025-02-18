#!/bin/bash

# Ordner mit SSH-Keys definieren (z. B. ~/.ssh)
KEYS_DIR="./keys"

# Zielverzeichnis für die komprimierten Dateien (optional)
BACKUP_DIR="./result"
QR_DIR="./qrcodes"

# Falls das Zielverzeichnis existiert, leeren
rm -rf "$BACKUP_DIR"
mkdir -p "$BACKUP_DIR"
rm -rf "$QR_DIR"
mkdir -p "$QR_DIR"

# Maximale Größe pro QR-Code in Bytes (z. B. 2953 Bytes für standardmäßige QR-Codes)
MAX_SIZE=2048

# Alle privaten SSH-Keys im Verzeichnis finden und komprimieren
for key in "$KEYS_DIR"/*; do
    # Prüfen, ob es sich um eine Datei handelt und keine öffentliche Key-Datei (.pub)
    if [[ -f "$key" && "$key" != *.pub ]]; then
        gzip -c "$key" > "$BACKUP_DIR/$(basename "$key").gz"
        echo "Komprimiert: $key -> $BACKUP_DIR/$(basename "$key").gz"

        # Datei aufteilen, falls sie zu groß für einen QR-Code ist
        FILE_SIZE=$(stat -f%z "$BACKUP_DIR/$(basename "$key").gz")
        if (( FILE_SIZE > MAX_SIZE )); then
            split -b $MAX_SIZE "$BACKUP_DIR/$(basename "$key").gz" "$BACKUP_DIR/$(basename "$key").gz.part"
            rm "$BACKUP_DIR/$(basename "$key").gz"
            echo "Datei aufgeteilt: $(basename "$key").gz -> mehrere Teile"
        fi
    fi
done

# QR-Codes für alle komprimierten und aufgeteilten Dateien erzeugen
for file in "$BACKUP_DIR"/*; do
    if [[ -f "$file" && -s "$file" ]]; then
        FILENAME=$(basename "$file")
        echo "QR-Code erstellt: $QR_DIR/$(basename "$file").png"
        base64 -i "$file" | qrencode -d 128 -o "$QR_DIR/$FILENAME.png"
        # magick -background white -fill black -gravity center -size 400x50 caption:"$FILENAME.png" "$QR_DIR/$FILENAME.png" -append "$QR_DIR/$FILENAME.png"
        # echo "QR-Code erstellt: $QR_DIR/$FILENAME.png mit Label $FILENAME"
    else
        echo "Überspringe leere Datei: $file"
    fi
done

echo "Alle SSH-Keys wurden erfolgreich komprimiert, ggf. aufgeteilt, in Base64 kodiert und als QR-Codes gespeichert. Sie befinden sich im Ordner $QR_DIR."
