# Commands to append a table using CAS REST APIs

### createSession
```
curl -X POST https://sasserver:8777/cas/sessions \
  -H 'Authorization: Bearer $ACCESSTOKEN' \
  -H 'Content-Type: application/vnd.sas.cas.session+json'
```

### createGlobalCaslib
```
curl -X POST https://sasserver:8777/cas/sessions//actions/table.addCaslib \
  -H 'Authorization: Bearer $ACCESSTOKEN' \
  -H 'Content-Type: application/json' \
  -d {"name":"HALLOWEEN","path":"/home/sasdemo/halloween","description":"HALLOWEEN","subDirectories":"false","permission":"PUBLICWRITE","session":"false","dataSource":{"srcType":"path"},"createDirectory":"true","hidden":"false","transient":"false"}
```

### copyDataSetIntoCaslib
This is a manual step of copying the data file to the Caslib path. There are various ways to copy/upload the data.

### createTempCaslib
```
curl -X POST https://sasserver:8777/cas/sessions/&lt;session=id&gt;/actions/table.addCaslib \
  -H 'Authorization: Bearer $ACCESSTOKEN' \
  -H 'Content-Type: application/json' \
  -d {"name":"TEMP","path":"/home/sasdemo/temp","description":"TEMP","subDirectories":"false","permission":"PUBLICWRITE","session":"false","dataSource":{"srcType":"path"},"createDirectory":"true","hidden":"false","transient":"false"}
```

### loadDataToMemory
```
curl -X POST https://sasserver:8777/cas/sessions//actions/table.loadTable
  -H 'Authorization: Bearer $ACCESSTOKEN' \
  -H 'Content-Type: application/json' \
  -d {"path":"costumesByYear.xlsx","caslib":"HALLOWEEN","importOptions":{"fileType":"EXCEL"},"casOut":{"caslib":"TEMP","name":"costumesByYear","promote":"true"}}
```

### createTempTableWithAppendData
```
curl -X PUT https://sasserver:8777/cas/sessions//actions/upload
  -H 'Authorization: Bearer $ACCESSTOKEN' \
  -H 'Content-Type: text/plain' \
  -H 'JSON-Parameters: {"casOut":{"caslib":"TEMP","name":"data2019","promote":"true"},"importOptions":{"fileType":"CSV"}}' \
  --data-binary $'Year,Costume\n2019,The Golden Girls\n2019,Pennywise'
```

### runDataStepToAppendData
```
curl -X POST https://sasserver:8777/cas/sessions//actions/runCode \
  -H 'Authorization: Bearer $ACCESSTOKEN' \
  -H 'Content-Type: application/json' \
  -d {"code": "data temp.costumesbyyear(append=force) ; set temp.data2019;run;"}
```

### saveAppendedTableBackToCaslib
```
curl -X POST https://sasserver:8777/cas/sessions//actions/table.save \
  -H 'Authorization: Bearer $ACCESSTOKEN' \
  -H 'Content-Type: application/json' \
  -d {"table":{"name":"costumesbyyear","caslib":"TEMP","singlePass":"false"},"name":"costumesbyyear","replace":"true","compress":"false","caslib":"HALLOWEEN","exportOptions":{"fileType":"BASESAS"}}
```

### deleteTempCaslib
```
curl -X POST https://sasserver:8777/cas/sessions//table.dropCaslib \
  -H 'Authorization: Bearer $ACCESSTOKEN' \
  -H 'Content-Type: application/json' \
  -d {"caslib":"TEMP"}
```

### deleteCASSession
```
curl -X POST https://sasserver:8777/cas/sessions/ \
  -H 'Authorization: Bearer $ACCESSTOKEN'
```