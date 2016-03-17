#!/usr/bin/env bash
set -e

if [ -z $1 ]; then
    PREFIX="${PWD}/accessoryfiles"
elif [ -d $1 ]; then
    PREFIX="${1}/accessoryfiles"
else
    PREFIX="$1"
fi
mkdir -p ${PREFIX}

files=( http://www.bioinformatics.babraham.ac.uk/projects/fastqc/fastqc_v0.11.4.zip
        http://downloads.sourceforge.net/project/bbmap/BBMap_35.82.tar.gz
        http://spades.bioinf.spbau.ru/release3.6.2/SPAdes-3.6.2-Linux.tar.gz
        https://downloads.sourceforge.net/project/quast/quast-3.2.tar.gz
        http://augustus.gobics.de/binaries/augustus.2.5.5.tar.gz
        http://busco.ezlab.org/files/BUSCO_v1.1b1.tar.gz
        https://github.com/samtools/samtools/releases/download/1.3/samtools-1.3.tar.bz2
        https://bitbucket.org/kokonech/qualimap/downloads/qualimap_v2.2.zip
       )

echo ${files[@]} | xargs -n 1 -P 8 wget -q -P ${PREFIX}

for clade in bacteria eukaryota fungi; do
    wget http://busco.ezlab.org/files/${clade}_buscos.tar.gz -P ${PREFIX};
    tar -zxf ${PREFIX}/${clade}_buscos.tar.gz -C ${PREFIX};
    rm ${PREFIX}/${clade}_buscos.tar.gz;
done

for a in $(ls -1 ${PREFIX}/*.tar.gz); do
tar -zxf $a $PREFIX;
rm $a;
done

for a in $(ls -1 ${PREFIX}/*.tar.bz2); do
 tar -jxf $a -C $PREFIX;
 rm $a;
done

for a in $(ls -1 ${PREFIX}/*.zip); do
 unzip $a -d -C $PREFIX;
 rm $a;
done
