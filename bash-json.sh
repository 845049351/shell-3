 #!/bin/bash

curl http://www.edusoho.com/version/edusoho >out.txt&&cat out.txt | jq . | jq .url |cat > url.txt&&tr -d \" < url.txt | cat > download.txt&&wget -O edusoho.tar.gz -i download.txt&& sudo tar -zxvf edusoho.tar.gz -C /var/www&&sudo chown www-data:www-data /var/www/edusoho/ -Rf

