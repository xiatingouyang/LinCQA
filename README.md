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

The original SQL queries for the StackOverflow workload is located at
```
benchmarks/stackoverflow/sqls/
```
Their corresponding rewritings are in 
```
benchmarks/stackoverflow/{rewriting}/
```
where ```rewriting``` can be ```lincqa```, ```conquer```and ```fastfo```.


## Worst case dataset

The original SQL queries for the worst case dataset is located at
```
benchmarks/worst/sqls/
```
Their corresponding rewritings are in 
```
benchmarks/worst/{rewriting}/
```
where ```rewriting``` can be ```lincqa```, ```conquer```and ```fastfo```.
