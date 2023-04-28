# LinCQA

This repository accompanies the paper [LinCQA: Faster Consistent Query Answering with Linear Time Guarantees](https://arxiv.org/abs/2208.12339), to appear in SIGMOD 2023. 

## Usage

Given a database schema stored in ```.json``` format (an example [here](https://github.com/xiatingouyang/LinCQA/blob/main/benchmarks/tpch/schemas.json)), the first-order rewriting of an acyclic SQL query using a specified algorithm ```algo``` can be generated by running the following command:

```
python3 rewriter.py -s <dir-to-schema.json> -i <dir-to-input-sql-file.sql> -algo <lincqa/conquer/fastfo>
```

Currently, the ```-algo``` flag only supports ```lincqa```. Implementations for ```conquer``` and ```fastfo``` can be found [here](https://github.com/Hacker0912/RecStep/tree/master/cqa).


## Rewriting

The rewritings of all queries generated by all CQA systems to reproduce the results in the paper and located in the following directories. 

### Synthetic dataset
The original SQL queries for the synthetic dataset is stored under
```
benchmarks/synthetic/sqls/
```
Their corresponding rewritings are in 
```
benchmarks/synthetic/{rewriting}/
```
where ```rewriting``` can be ```lincqa```, ```conquer```and ```fastfo```.


### TPC-H dataset

The original SQL queries for the TPC-H workload is stored under
```
benchmarks/tpch/sqls/
```
Their corresponding rewritings are in 
```
benchmarks/tpch/{rewriting}/
```
where ```rewriting``` can be ```lincqa```, ```conquer```and ```fastfo```.


### StackOverflow dataset

The original SQL queries for the StackOverflow workload is stored under
```
benchmarks/stackoverflow/sqls/
```
Their corresponding rewritings are in 
```
benchmarks/stackoverflow/{rewriting}/
```
where ```rewriting``` can be ```lincqa```, ```conquer```and ```fastfo```.

We note that the LinCQA rewriting can be implemented using either views or intermediate tables, stored in 

```
benchmarks/stackoverflow/{rewriting}/views
```
and
```
benchmarks/stackoverflow/{rewriting}/materialize
```
respectively.

