# LinCQA

The repository contains the extended version of the paper **LinCQA: Faster Consistent Query Answering with Linear Time Guarantees** and the rewritings of all queries by all CQA systems to reproduce the results in the paper.

## Synthetic dataset
The original SQL queries for the synthetic dataset is stored under
```
benchmarks/synthetic/sqls/
```
Their corresponding rewritings are in 
```
benchmarks/synthetic/{rewriting}/
```
where ```rewriting``` can be ```lincqa```, ```conquer```and ```fastfo```.


## TPC-H dataset

The original SQL queries for the TPC-H workload is stored under
```
benchmarks/tpch/sqls/
```
Their corresponding rewritings are in 
```
benchmarks/tpch/{rewriting}/
```
where ```rewriting``` can be ```lincqa```, ```conquer```and ```fastfo```.


## StackOverflow dataset

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

