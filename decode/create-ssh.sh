#!/bin/bash

# Ordner mit den QR-Code-Bildern
QR_DIR="./qrcodes"
RESTORE_DIR="./sshkeys"

# Sicherstellen, dass das Wiederherstellungsverzeichnis existiert
rm -rf "$RESTORE_DIR"
mkdir -p "$RESTORE_DIR"

# QR-Codes entschlüsseln und Base64 dekodieren
for qr in "$QR_DIR"/*.png; do
    if [[ -f "$qr" ]]; then
        zbarimg --raw "$qr" | base64 --decode > "$RESTORE_DIR/$(basename "$qr" .png)"
        echo "Dekodiert: $qr -> $RESTORE_DIR/$(basename "$qr" .png)"
    fi
done

# Falls Dateien gesplittet wurden, sie wieder zusammenfügen
if ls "$RESTORE_DIR"/*.gz.part* 1> /dev/null 2>&1; then
    for file in "$RESTORE_DIR"/*.gz.part*; do
        base_name="${file%.part*}"
        cat "$file" >> "$base_name"
        echo "Zusammengefügt: $file -> $base_name"
        rm "$file"
    done
fi

# Entfernen doppelter .gz.gz-Endungen falls vorhanden
for file in "$RESTORE_DIR"/*.gz.gz; do
    if [[ -f "$file" ]]; then
        mv "$file" "${file%.gz}"
        echo "Umbenannt: $file -> ${file%.gz}"
    fi
done

# Entpacken der wiederhergestellten Gzip-Dateien
for file in "$RESTORE_DIR"/*.gz; do
    if [[ -f "$file" ]]; then
        gunzip "$file"
        echo "Entpackt: $file"
    fi
done


# Öffentliche SSH-Keys (*.pub) wiederherstellen
for key in "$RESTORE_DIR"/*; do
    if [[ -f "$key" && "$key" != *.pub ]]; then
        chmod 600 "$key"
        ssh-keygen -y -f "$key" > "$key.pub"
        echo "Öffentlicher Schlüssel generiert: $key.pub"
    fi
done

echo "Wiederherstellung abgeschlossen. Die SSH-Keys befinden sich im Ordner $RESTORE_DIR."