#/bin/sh

touch missing_strings.txt
chmod 777 missing_strings.txt

find . -type f | grep ".swift" > swiftindex.temp

while IFS= read -r filename
do
  grep -o "NSLocalizedString(\"[^\")]*\", comment:\s*\"\")" "$filename" > strings.temp
  while IFS= read -r localizable
  do
    echo $localizable
    replacement=$(./transform.swift $localizable)
    echo "$replacement"
    sed -i .bak "s/$localizable/$replacement/g" $filename
    rm "$filename.bak"
  done < strings.temp
  rm strings.temp
done < swiftindex.temp
rm swiftindex.temp