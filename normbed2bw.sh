name=`basename $1 .norm.bed`
lab=`dirname $1`
type=$2

# Seperate strand
# normalized by the number of reads mapped to genome excluding the ones mapped to the known non-coding RNAs
# the 4th column in the stats files

name1=${name%%.xkxh}
name2=${name1%%.uniqmap}
norm=`grep ${name2} /home/wangj2/zlab_ucsc/dm3/zlab.dm3.norm.factor | cut -f2`

##zcat $1.gz | awk -F "\t" -v norm=$norm '{OFS="\t"; if($4=="+" && length($5)>=23) print $1,$2-1,$3,$6","$7","norm}' > $name.bed.plus.pirna 
##zcat $1.gz | awk -F "\t" -v norm=$norm '{OFS="\t"; if($4=="-" && length($5)>=23) print $1,$2-1,$3,$6","$7","norm}' > $name.bed.minus.pirna

##zcat $1.gz | awk -F "\t" -v norm=$norm '{OFS="\t"; if($4=="+" && length($5)<23) print $1,$2-1,$3,$6","$7","norm}' > $name.bed.plus.sirna
##zcat $1.gz | awk -F "\t" -v norm=$norm '{OFS="\t"; if($4=="-" && length($5)<23) print $1,$2-1,$3,$6","$7","norm}' > $name.bed.minus.sirna

# Clip the P-elements that are attached by the Jia's pipeline
##bedClip $name.bed.plus.pirna /gbdb/dm3/dm3.chromInfo $name.bed.plus.pirna.clip
##bedClip $name.bed.minus.pirna /gbdb/dm3/dm3.chromInfo $name.bed.minus.pirna.clip

##bedClip $name.bed.plus.sirna /gbdb/dm3/dm3.chromInfo $name.bed.plus.sirna.clip
##bedClip $name.bed.minus.sirna /gbdb/dm3/dm3.chromInfo $name.bed.minus.sirna.clip

# convert norm.bed to bedGraph
##sort $name.bed.plus.pirna.clip | bedItemOverlapCountWithScore dm3 stdin -chromSize=/gbdb/dm3/dm3.chromInfo > $name.plus.pirna.norm.bedGraph
##sort $name.bed.minus.pirna.clip | bedItemOverlapCountWithScore dm3 stdin -chromSize=/gbdb/dm3/dm3.chromInfo > $name.minus.pirna.bedGraph

##sort $name.bed.plus.sirna.clip | bedItemOverlapCountWithScore dm3 stdin -chromSize=/gbdb/dm3/dm3.chromInfo > $name.plus.sirna.norm.bedGraph
##sort $name.bed.minus.sirna.clip | bedItemOverlapCountWithScore dm3 stdin -chromSize=/gbdb/dm3/dm3.chromInfo > $name.minus.sirna.bedGraph

##awk -F "\t" '{OFS="\t"; print $1,$2,$3,-$4}' $name.minus.pirna.bedGraph > $name.minus.pirna.norm.bedGraph
##awk -F "\t" '{OFS="\t"; print $1,$2,$3,-$4}' $name.minus.sirna.bedGraph > $name.minus.sirna.norm.bedGraph

# convert normalized bedGraph to bigWig
##bedGraphToBigWig $name.plus.pirna.norm.bedGraph /gbdb/dm3/dm3.chromInfo $name.plus.pirna.norm.bw
##bedGraphToBigWig $name.minus.pirna.norm.bedGraph /gbdb/dm3/dm3.chromInfo $name.minus.pirna.norm.bw

##bedGraphToBigWig $name.plus.sirna.norm.bedGraph /gbdb/dm3/dm3.chromInfo $name.plus.sirna.norm.bw
##bedGraphToBigWig $name.minus.sirna.norm.bedGraph /gbdb/dm3/dm3.chromInfo $name.minus.sirna.norm.bw

# move the bigWig to the gbdb directory
##mv $name.*.bw /gbdb/dm3/$lab/

# add the track name into the trackDb.ra files
#echo "Patch $name"
perl $type.normbed2ra.pl $name > temp.ra
#encodePatchTdb temp.ra trackDb_umass/$lab.$type.ra

track=`egrep "        track" temp.ra | egrep "PiU|PiA" | cut -d " " -f10 | head -1`
hgBbiDbLink dm3 $track /gbdb/dm3/$lab/$name.plus.pirna.norm.bw
track=`egrep "        track" temp.ra | egrep "PiU|PiA" | cut -d " " -f10 | tail -1`
hgBbiDbLink dm3 $track /gbdb/dm3/$lab/$name.minus.pirna.norm.bw

track=`egrep "        track" temp.ra | egrep "SiU|SiA" | cut -d " " -f10 | head -1`
hgBbiDbLink dm3 $track /gbdb/dm3/$lab/$name.plus.sirna.norm.bw
track=`egrep "        track" temp.ra | egrep "SiU|SiA" | cut -d " " -f10 | tail -1`
hgBbiDbLink dm3 $track /gbdb/dm3/$lab/$name.minus.sirna.norm.bw

# clean up the unused files
##rm $name.*
