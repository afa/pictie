# Pictie

TODO: Write a gem description

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

## Contributing

1. Fork it ( https://github.com/[my-github-username]/pictie/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
