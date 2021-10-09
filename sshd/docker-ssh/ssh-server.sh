docker run -d \
	  --name=zssh-server \
	    --hostname=zssh-server `#optional` \
	      -e PUID=0 \
	        -e PGID=0 \
		  -e TZ=Asia/Shanghai \
			  -e SUDO_ACCESS=false `#optional` \
			    -e PASSWORD_ACCESS=true `#optional` \
			      -e USER_PASSWORD=cmg2021! `#optional` \
				  -e USER_NAME=root `#optional` \
				    -p 8005:2222 \
				      -v /zach-config/openssh-config:/config \
				      -v /UHD/enhance_fix:/UHD/enhance_fix \
				      -v /UHD/enhance_fix/ys_data:/ys_data \
				      -v /nfs-data:/nfs-data \
				        --restart unless-stopped \
					  zssh-server:v1.1
                      # ghcr.io/linuxserver/openssh-server
