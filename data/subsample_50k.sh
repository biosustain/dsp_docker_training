  #Subsample 50 000 reads randomly (keep random sees constant for both --> -s100)
  seqtk sample -s100 SRR9681150_1.fastq 50000 > SRR9681150_1_sub_50k.fastq
  seqtk sample -s100 SRR9681150_2.fastq 50000 > SRR9681150_2_sub_50k.fastq