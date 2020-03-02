# Manipulation of sequence data with Bioconductor
#https://bioconductor.org/packages/release/workflows/vignettes/sequencing/inst/doc/sequencing.html

library(BiocManager)
library(sequencing)

library(Biostrings)
d <- DNAString("TTGAAAA-CTC-N")
length(d)


# DNA sequence from FASTA files
ah <- AnnotationHub()

ah2 <- query(ah, c("fasta", "homo sapiens", "Ensembl", "cdna"))
dna <- ah2[["AH68262"]]
dna

getSeq(dna)
# Doesn't work.... ?

library(VariantAnnotation)
fl <- system.file("extdata", "chr22.vcf.gz", package="VariantAnnotation")
vcf <- readVcf(fl, "hg19")

vcf <- readVcf()