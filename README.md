# Homelab

## Docker-Compose

All configuration and compose files have been built for a seamless deployment experience.  
Just pull down the repo, create the necessary .env files from the .env.template,  
Then run the _docker compose_ command or use a GUI like Komodo.

Get started here with the overall [readme](docker-compose/readme.md).

<table>
	<tr>
		<th>Service</th>
		<th>Description</th>
	</tr>
	<tr>
		<td><a href="docker-compose/service-code/service-code.compose.yml">Code Server</a></td>
		<td>VS Code in a browser</td>
	</tr>
	<tr>
		<td><a href="docker-compose/service-guacamole/readme.md">Apache Guacamole</a></td>
		<td>Web RDP, SHH, etc</td>
	</tr>
	<tr>
		<td><a href="docker-compose/service-komodo/readme.md">Komodo</a></td>
		<td>Docker Compose Web GUI</td>
	</tr>
	<tr>
		<td><a href="docker-compose/service-plex/service-plex.compose.yml">Plex Media Server</a></td>
		<td>Streaming | HW Transcoding</td>
	</tr>
	<tr>
		<td><a href="docker-compose/service-torrent/service-torrent.compose.yml">Torrent Services</a></td>
		<td>Download | Request</td>
	</tr>
	<tr>
		<td><a href="docker-compose/service-portainer/readme.md">Portainer</a></td>
		<td>Docker Compose Web GUI</td>
	</tr>
	<tr>
		<td><a href="docker-compose/service-proxy/readme.md">Traefik and Authelia</a></td>
		<td>Reverse Proxy | Authentication</td>
	</tr>
	<tr>
		<td><a href="docker-compose/service-pterodactyl/readme.md">Pterodactyl</a></td>
		<td>Private Game Server Hosting</td>
	</tr>
</table>
