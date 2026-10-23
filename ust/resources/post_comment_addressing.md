 After addressing OUST or peer comments, run the following commands to refresh the data.
 These commands assume the correct profile is set. To verify:

```
ust profile show
```

To switch:
```powershell
ust profile set xx-ust 
ust profile set xx-release 
```

```powershell
ust audit-dataset --yes
ust populate-unreg --yes
ust generate-views --yes
ust qa --yes
ust populate --delete-existing --yes
ust export-template --yes
ust export-control-summary --yes
``` 

To preview one view in the console without creating or modifying the SQL file:

```powershell
ust generate-views --table-name ust_compartment_substance --print-console --no-write-sql --yes
```


