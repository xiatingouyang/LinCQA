cd worst
mkdir results
mkdir data
gcc gen.c -o gen

for algo in lincqa-sql conquer fastfo; do

        query=2path

        b=800
        c=800

        for k in {0..8}; do
                let a=120+460*k
                let N=1000000+500000*k
                let incon=100*a*b+100*b*c
                let total=2*N
                let ratio=incon/total
                echo $a $b $c $N $ratio

                sqlcmd -S localhost -U sa -P cqa2022! -i reset-worst.sql
                ./gen $a $b $N > data/r_1.csv
                ./gen $b $c $N > data/r_2.csv
                ./gen 2 2 100 > data/r_3.csv
                python3 ../bulk-populate.py schema.json dbinfo.json

                for it in {1..3}; do
                        { time sqlcmd -S localhost -U sa -P cqa2022! -d worst -i ${algo}/${query}.sql > output ; } 2>> results/${algo}_${a}_${b}_${c}.txt
                done

        done

        N=1000000

        for a in {100..1000..90}; do
                let incon=100*a*b+100*b*c
                let total=2*N
                let ratio=incon/total
                echo $a $b $c $N $ratio

                sqlcmd -S localhost -U sa -P cqa2022! -i reset-worst.sql
                ./gen $a $b $N > data/r_1.csv
                ./gen $b $c $N > data/r_2.csv
                ./gen 2 2 100 > data/r_3.csv
                python3 ../bulk-populate.py schema.json dbinfo.json

                for it in {1..3}; do
                        { time sqlcmd -S localhost -U sa -P cqa2022! -d worst -i ${algo}/${query}.sql > output ; } 2>> results/${algo}_${a}_${b}_${c}.txt
                done

        done


        query=3path
        b=120
        c=120
        d=120

        for k in {0..8}; do 
                let a=120+180*k
                let N=1000000+500000*k
                let incon=100*a*b+100*b*c+100*c*d
                let total=3*N
                let ratio=incon/total
                echo $a $b $c $d $N $ratio 

                sqlcmd -S localhost -U sa -P cqa2022! -i reset-worst.sql
                ./gen $a $b $N > data/r_1.csv
                ./gen $b $c $N > data/r_2.csv
                ./gen $c $d 100 > data/r_3.csv
                python3 ../bulk-populate.py schema.json dbinfo.json

                for it in {1..3}; do
                        { time sqlcmd -S localhost -U sa -P cqa2022! -d worst -i ${algo}/${query}.sql > output ; } 2>> results/${algo}_${a}_${b}_${c}_${d}.txt
                done
        done

        N=1000000
        for a in {200..8000..600}; do
                let incon=100*a*b+100*b*c+100*c*d
                let total=3*N
                let ratio=incon/total
                echo $a $b $c $d $N $ratio 

                sqlcmd -S localhost -U sa -P cqa2022! -i reset-worst.sql
                ./gen $a $b $N > data/r_1.csv
                ./gen $b $c $N > data/r_2.csv
                ./gen $c $d 100 > data/r_3.csv
                python3 ../bulk-populate.py schema.json dbinfo.json

                for it in {1..3}; do
                        { time sqlcmd -S localhost -U sa -P cqa2022! -d worst -i ${algo}/${query}.sql > output ; } 2>> results/${algo}_${a}_${b}_${c}_${d}.txt
                done
        done
done

