#!/usr/bin/perl -w
use strict;
use PerlIO::gzip;


if(@ARGV != 2){
	print "Usage: perl $0 <reference> CX_report.txt.gz > <out>\n";
	exit;
}

my $ref = $ARGV[0];
my %ref;
open IN,"$ref" or die $!;#genome.fa
my ($Chr,$seq) = ('','');
while(<IN>)
{
        chomp;
        if (/>/){
                $_ =~ />(.*)/;
                my $tmp_chr = $1;
                if ($tmp_chr ne $Chr){
                        if ($seq ne ''){
                                $ref{$Chr} = $seq;
                                $seq = '';
                        }
                        $Chr = $tmp_chr;
                }
                next;
        }
        $seq .= $_;
}
$ref{$Chr} = $seq;
close IN;

#print $ref{$Chr};

print "#Chr\tPos\tChain\tMet\tUnMet\tMetRate\tRef_context\n";
my %hash;
open IN, "<:gzip","$ARGV[1]" or die $!;
while(<IN>){
	chomp;
	my @a = split /\s+/,$_;
	my $chr = $a[0];
	my $pos = $a[1];
	my $strand = $a[2];
	my $met = $a[3];
	my $unmet = $a[4];
	my $depth = $a[3]+$a[4];
	my $str = "";
	next if ($chr =~ /random/ or $chr eq "chrM");
	next if $depth < 1;
	my $tmp_pos = $pos - 1; #currently position
	if ($strand eq "+"){
		$str = substr($ref{$chr},$tmp_pos-1,3);#may need to be changed 
		$str = uc $str;
		if (length($str) < 3){
			next;
		}
	}
	elsif ($strand eq "-"){
                next if ($tmp_pos < 2);
                if ($tmp_pos >= 2){
                        $tmp_pos = $tmp_pos - 1;
                        $str = substr($ref{$chr},$tmp_pos,3);
                }
                $str = reverse $str;
                $str = uc $str;
                $str =~ tr/ATGC/TACG/;
        }
	my $rate;
	if ($depth>0){
		$rate = $met/($unmet+$met);
	}

	print "$chr\t$pos\t$strand\t$met\t$unmet\t$rate\t$str\n";
}
close IN;
