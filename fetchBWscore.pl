#!/usr/bin/perl

die "perl $0 <bigwig> <anchor bed> <bw> <step>\n" if @ARGV<4;

my $bw=$ARGV[2];
my $p=2*$bw/$ARGV[3];

open anchor,$ARGV[1];
while(<anchor>)
{
	chomp;
	my ($chr,$pos,$strand)=(split)[0,1,5];
	my $s=$pos-$bw;
	my $e=$pos+$bw;
	next if $s<0;
	my $l=`bigWigSummary $ARGV[0] $chr $s $e $p 2>/dev/null`;
	chomp $l;
	my @s=();
	if($l eq "")
	{
		@s=(0)x$p; 
	}
	else
	{
		$l=~s/n\/a/0/g;
		@s=split("\t",$l);
		@s=reverse @s if $strand eq "-";
	}
	print join("\t",@s),"\n";
}
