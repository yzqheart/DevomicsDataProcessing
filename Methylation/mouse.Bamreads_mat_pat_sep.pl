#!/usr/bin/perl -w
use strict;

if (@ARGV != 4){
	die "Usage: perl $0  <sample> <chr> <bam> <embryo> \n";
}

my $sample=$ARGV[0];
my $chr=$ARGV[1];
my $bam=$ARGV[2];
my $embryo=$ARGV[3];
my %hash;

my $dir="/mnt/data/kongsiming/zhaifan/test_pat_mat/SNPsepBam";

open OUT_Pat_bam,">$dir/$embryo/$sample/$sample.$chr.pat.sam" or die $!;
open OUT_Pat_snp,">$dir/$embryo/$sample/$sample.$chr.pat.snp" or die $!;
open OUT_Mat_bam,">$dir/$embryo/$sample/$sample.$chr.mat.sam" or die $!;
open OUT_Mat_snp,">$dir/$embryo/$sample/$sample.$chr.mat.snp" or die $!;

my @Region_CpGs;
open I,"/mnt/data/kongsiming/zhaifan/test_pat_mat/ZHYZ/ZHYZ.$chr" or die $!;
while (<I>){
        chomp;
        my @f = split(/\s+/,$_);
	next if (/CHROM/);
	my $pos=$f[1];
	my $pat=$f[3];
	my $mat=$f[4];
	my $type=$f[5];
	push( @Region_CpGs, $pos);
	$hash{$pos}{$type}{"pat"}=$pat;
	$hash{$pos}{$type}{"mat"}=$mat;
}
close I;

print OUT_Pat_snp "#Read_id\tread_mapped_strand\tChr\tPos\tgDNA_pat\tgDNA_mat\tSeq_pat\tSeq_mat\tSNP_type\n";
print OUT_Mat_snp "#Read_id\tread_mapped_strand\tChr\tPos\tgDNA_pat\tgDNA_mat\tSeq_pat\tSeq_mat\tSNP_type\n";

# Read bam file
open IN,"samtools view $bam $chr |" or die $!;

while(my $line= <IN>){
	chomp $line;
	my @a = split /\s+/,$line;
	my $flag = $a[1];
	my $map_start = $a[3];
	my $read_length = length($a[9]);
	my $read_id = $a[0];
	$read_id =~ s/\/\d$//;
#	push(@read_id, $read_id);
	# reads mapped to '-' strand
	if ( $flag & 0x10 ){ #SEQ being reverse complemented
		foreach my $i (@Region_CpGs){
            next if ($i < $map_start);
            last if ($i > ($map_start + $read_length - 1)); #only reads woth SNP
		    foreach my $j (keys %{$hash{$i}}){
				next if ( $hash{$i}{$j}{"pat"} eq "A" and $hash{$i}{$j}{"mat"} eq "G" );
				next if ( $hash{$i}{$j}{"pat"} eq "G" and $hash{$i}{$j}{"mat"} eq "A" );
				my $pat_allel = $hash{$i}{$j}{"pat"};
				my $mat_allel = $hash{$i}{$j}{"mat"};
				$pat_allel =~ tr/ATCG/ATCA/;
				$mat_allel =~ tr/ATCG/ATCA/;
				my $read_pos = $i - $map_start  + 1; 
				my $read_base = substr($a[9], ($read_pos - 1), 1);
									
				$read_base =~ tr/ATCG/ATCA/; #yan, 2018-5-1
							
				if ( ($j eq "type3") or ($j eq "type4") ){
					if ($read_base eq $pat_allel){
						print OUT_Pat_bam "$line\n";
						print OUT_Pat_snp "$read_id\t-\t$chr\t$i\t$hash{$i}{$j}{'pat'}\t$hash{$i}{$j}{'mat'}\t$pat_allel\t$mat_allel\tpaternal\n";
					}
					elsif ($read_base eq $mat_allel){
						print OUT_Mat_bam "$line\n";
						print OUT_Mat_snp "$read_id\t-\t$chr\t$i\t$hash{$i}{$j}{'pat'}\t$hash{$i}{$j}{'mat'}\t$pat_allel\t$mat_allel\tmaternal\n";
					}
				}


            }
		}
	}
	else {  #reads mapped to "+" strand
		foreach my $i (@Region_CpGs){
		next if ($i < $map_start);
		last if ($i > ($map_start + $read_length - 1));
		foreach my $j (keys %{$hash{$i}}){
			next if ( $hash{$i}{$j}{"pat"} eq "T" and $hash{$i}{$j}{"mat"} eq "C" );
			next if ( $hash{$i}{$j}{"pat"} eq "C" and $hash{$i}{$j}{"mat"} eq "T" );
			my $pat_allel = $hash{$i}{$j}{"pat"};
			my $mat_allel = $hash{$i}{$j}{"mat"};
			$pat_allel =~ tr/ATCG/ATTG/;
			$mat_allel =~ tr/ATCG/ATTG/;
			my $read_pos = $i - $map_start + 1;
			my $read_base = substr($a[9], ($read_pos - 1), 1);
			
			$read_base =~ tr/ATCG/ATTG/; #yan, 2018-5-1
			
			if ( ($j eq "type3") or ($j eq "type4") ){
				if ($read_base eq $pat_allel){
					print OUT_Pat_bam "$line\n";
					print OUT_Pat_snp "$read_id\t+\t$chr\t$i\t$hash{$i}{$j}{'pat'}\t$hash{$i}{$j}{'mat'}\t$pat_allel\t$mat_allel\tpaternal\n";
				}
				elsif ($read_base eq $mat_allel){
					print OUT_Mat_bam "$line\n";
					print OUT_Mat_snp "$read_id\t+\t$chr\t$i\t$hash{$i}{$j}{'pat'}\t$hash{$i}{$j}{'mat'}\t$pat_allel\t$mat_allel\tmaternal\n";
				}
			}


		}
	}
}
}

close IN;
close OUT_Pat_bam;
close OUT_Pat_snp;
close OUT_Mat_bam;
close OUT_Mat_snp;

