function log() {
  d=$(date "+%F %R")
  echo "${d}: $1"
}


log "download file"

aws --no-verify-ssl s3api get-object --bucket "{{ .Values.dataloader.bucket }}" --endpoint-url {{ .Values.dataloader.endpoint }} --key "{{ .Values.dataloader.file }}" /data/input.sql
ls -lh /data
log "Begin to load file into database"

pg_restore -h cnpg-old-data-rw -U postgres -d app /data/input.sql

log "End loading file into database"
