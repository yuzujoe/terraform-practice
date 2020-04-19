## AWS CLIによるSSMパラメーターストアの操作

- 保存
```$bash
 aws ssm put-parameter --name 'plain_name' --value 'plain value' --type string
```

- 参照
```$bash
aws ssm get-parameter --output text --name 'plain _name' --query Parameter.Value plain value 
```

-　更新
```$bash
aws ssm put-parameter --name 'plain_name' -type String --value 'modified_value' --overwrite
```

- 暗号化
```$bash
aws ssm put-parameter --name 'encryption_name' --value 'encryption value' --type SecureString
```

- 暗号化の参照
```$bash
aws ssm put-parameter --output text --query Parameter.Value --name 'encryption_name' --with-decryption encryption value
```
