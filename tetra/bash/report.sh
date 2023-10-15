# must be in reports dir
tetra-report-encrypt(){
   tar ca audit.txt summary.html | \
   tetra-encrypt-stdio  > \
   report_$(date +%s).tar.enc
}

tetra-report-decrypt(){
   cat $1 | tetra-decrypt-stdio |tar xv
}