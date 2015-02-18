# Pictie

## NGINX upstream
upstream pictie { server 0.0.0.0:3000; } #dev
upstream pictie { server unix://...thin.sock; } #prod

## NGINX location
        location ~ /api/v1/picture/size/(\d+)-(\d+) {
          set $width $1;
          set $height $2;
          proxy_pass http://pictie;
          image_filter resize $width $height;
        }

        location ~ /api/v1/picture {
          proxy_pass http://pictie;
        }

## Хотелки

надо postges, etcd, libgd(v2)

## A12n

config/app.yml: задать ключ, storage
