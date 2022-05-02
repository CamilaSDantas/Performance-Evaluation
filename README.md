# Performance Evaluation

Resolução de questões sobre monitoramento de sistemas

## Execução

### Q1

O script `q1.sh` recebe 3 parâmetros: `pid da aplicação`, `número de amostras` e `tempo entre amostras (em milisegundos)`.

No exemplo abaixo, serão feitas 500 coletas da aplicação `firefox` com intervalo entre elas de 1000ms:

```bash
bash q1.sh $(pidof firefox | awk 'NF>1{print $NF}') 500 1000 | tee firefox.csv
```

Abaixo está um exemplo do CSV gerado:

| uptime   | num_threads | memory_usage | cpu_time |
| -------- | ----------- | ------------ | -------- |
| 1.020000 | 60          | 99591        | 0.690000 |
| 2.020000 | 105         | 180473       | 1.600000 |
| 3.030000 | 115         | 190249       | 2.390000 |
| 4.030000 | 116         | 202664       | 2.770000 |
| 5.040000 | 116         | 205780       | 2.930000 |
