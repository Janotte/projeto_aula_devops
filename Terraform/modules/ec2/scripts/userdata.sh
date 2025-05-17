#!/bin/bash
# Atualiza pacotes
sudo yum update -y

# Instala o SSM Agent
sudo yum install -y https://s3.us-east-2.amazonaws.com/amazon-ssm-us-east-2/latest/linux_amd64/amazon-ssm-agent.rpm

# Habilita a inicialização automática do agente SSM
sudo systemctl start amazon-ssm-agent

# Inicializa o agente SSM
sudo systemctl start amazon-ssm-agent

# Instala o AWS CLI
sudo yum install -y aws-cli

# Instala Apache e PHP
sudo yum install -y httpd php php-cli php-json php-common unzip

# Habilita e inicia o Apache
sudo systemctl enable httpd
sudo systemctl start httpd

# Instala o Composer
cd /tmp
sudo php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
sudo php composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Cria diretório para aplicação
sudo mkdir -p /var/www/html/devops
cd /var/www/html/devops

# Instala o AWS SDK para PHP via Composer
# composer require aws/aws-sdk-php --no-interaction --no-progress --with-all-dependencies
sudo COMPOSER_ALLOW_SUPERUSER=1 composer require aws/aws-sdk-php --no-interaction

# Cria index.php
sudo tee /var/www/html/devops/index.php > /dev/null <<'EOF'
<!DOCTYPE html>
<html lang="pt-br">
	<head>
		<meta charset="UTF-8" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<title>Home</title>
		<style>
			* {
				box-sizing: border-box;
			}

			body {
				font-family: Arial, sans-serif;
				background-color: #f4f4f4;
				margin: 0;
				padding: 0;
			}

			section {
				max-width: 90%;
				margin: 40px auto;
				padding: 20px;
			}

			nav {
				background-color: #616161;
				padding: 10px 20px;
				border-radius: 5px;
				box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
				display: flex;
				justify-content: space-around;
				flex-wrap: wrap;
			}

			nav a {
				color: #f8f8f8;
				text-decoration: none;
				margin: 5px;
				font-weight: bold;
			}

			main {
				background-color: #ffffff;
				margin-top: 20px;
				padding: 30px 20px;
				border-radius: 5px;
				box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
			}

			h1 {
				font-size: 24px;
				margin-bottom: 20px;
				color: #333;
			}
		</style>
	</head>
	<body>
		<section>
			<nav>
				<a href="index.php">Início</a>
				<a href="s3.php">Enviar para S3</a>
				<a href="listar.php">Listar Bucket</a>
			</nav>
			<main>
				<h1>Bem-vindo ao App para Alunos de DevOps!</h1>

				<p>Este é um aplicativo simples para demonstrar o upload de arquivos para o S3.</p>
			</main>
		</section>
	</body>
</html>
EOF


# Cria s3.php
sudo tee /var/www/html/devops/s3.php > /dev/null <<'EOF' 
<!DOCTYPE html>
<html lang="pt-br">
<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>Upload para S3</title>
	<style>
		* {
			box-sizing: border-box;
		}

		body {
			font-family: Arial, sans-serif;
			background-color: #f4f4f4;
			margin: 0;
			padding: 0;
		}

		section {
			max-width: 90%;
			margin: 40px auto;
			padding: 20px;
		}

		nav {
			background-color: #616161;
			padding: 10px 20px;
			border-radius: 5px;
			box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
			display: flex;
			justify-content: space-around;
			flex-wrap: wrap;
		}

		nav a {
			color: #f8f8f8;
			text-decoration: none;
			margin: 5px;
			font-weight: bold;
		}

		main {
			background-color: #ffffff;
			margin-top: 20px;
			padding: 30px 20px;
			border-radius: 5px;
			box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
		}

		h1 {
			font-size: 24px;
			margin-bottom: 20px;
			color: #333;
		}

		form {
			display: flex;
			flex-direction: column;
			gap: 15px;
		}

		label {
			font-weight: bold;
			color: #333;
		}

		input[type="file"]::file-selector-button {
			background-color: #4CAF50;
			color: white;
			border: none;
			border-radius: 5px;
			padding: 10px 20px;
			cursor: pointer;
			font-family: inherit;
			transition: background-color 0.3s ease;
		}

		input[type="file"]::file-selector-button:hover {
			background-color: #0f9716;
		}

		button {
			background-color: #4CAF50;
			color: white;
			padding: 10px 20px;
			border: none;
			border-radius: 5px;
			cursor: pointer;
			transition: background-color 0.3s ease;
		}

		button:hover {
			background-color: #0f9716;
		}
	</style>
</head>
<body>
	<section>
		<nav>
			<a href="index.php">Início</a>
			<a href="s3.php">Enviar para S3</a>
			<a href="listar.php">Listar Bucket</a>
		</nav>

		<main>
			<h1>Upload de Arquivos para o S3</h1>

			<form action="upload.php" method="post" enctype="multipart/form-data">
				<label for="file">Escolha um arquivo:</label>
				<input type="file" name="file" id="file" required />
				<button type="submit">Enviar</button>
			</form>
		</main>
	</section>
</body>
</html>
EOF

# Cria upload.php
sudo tee /var/www/html/devops/upload.php > /dev/null <<'EOF' 
<?php

require 'vendor/autoload.php';

use Aws\S3\S3Client;
use Aws\Exception\AwsException;

if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_FILES['file'])) {
    $bucketName = trim('devops-dev.supptech.net.br');

    $file = $_FILES['file'];

    if ($file['error'] === UPLOAD_ERR_OK) {
        $filePath = $file['tmp_name'];
        $fileName = basename($file['name']);

        try {
            $s3 = new S3Client([
                'region' => 'us-east-2',
                'version' => 'latest',
            ]);

            $result = $s3->putObject([
                'Bucket'     => $bucketName,
                'Key'        => $fileName,
                'SourceFile' => $filePath,
            ]);

            echo "✅ Arquivo enviado com sucesso: <a href='{$result['ObjectURL']}' target='_blank'>{$result['ObjectURL']}</a>";
        } catch (AwsException $e) {
            echo "❌ Erro ao enviar arquivo: " . $e->getMessage();
        }
    } else {
        echo "❌ Erro no upload do arquivo.";
    }
} else {
    echo "❌ Nenhum arquivo enviado.";
}
EOF

# Cria listar.php
sudo tee /var/www/html/devops/listar.php > /dev/null <<'EOF' 
<?php
require 'vendor/autoload.php';

use Aws\S3\S3Client;
use Aws\Exception\AwsException;

// Ativa exibição de erros (modo dev)
ini_set('display_errors', 1);
error_reporting(E_ALL);

// Configurações
$bucketName = trim('devops-dev.supptech.net.br');


try {
    $s3 = new S3Client([
        'region' => 'us-east-2',
        'version' => 'latest'
    ]);

    $result = $s3->listObjectsV2([
        'Bucket' => $bucketName
    ]);

    $objects = $result['Contents'] ?? [];
} catch (AwsException $e) {
    die("Erro ao listar objetos: " . $e->getAwsErrorMessage());
}
?>

<!DOCTYPE html>
<html lang="pt-br">
<head>
	<meta charset="UTF-8" />
	<meta name="viewport" content="width=device-width, initial-scale=1.0" />
	<title>Listar Arquivos</title>
	<style>
		* {
			box-sizing: border-box;
		}

		body {
			font-family: Arial, sans-serif;
			background-color: #f4f4f4;
			margin: 0;
			padding: 0;
		}

		section {
			max-width: 90%;
			margin: 40px auto;
			padding: 20px;
		}

		nav {
			background-color: #616161;
			padding: 10px 20px;
			border-radius: 5px;
			box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
			display: flex;
			justify-content: space-around;
			flex-wrap: wrap;
		}

		nav a {
			color: #f8f8f8;
			text-decoration: none;
			margin: 5px;
			font-weight: bold;
		}

		main {
			background-color: #ffffff;
			margin-top: 20px;
			padding: 30px 20px;
			border-radius: 5px;
			box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
		}

		h1 {
			font-size: 24px;
			margin-bottom: 20px;
			color: #333;
		}

		table {
			width: 100%;
			border-collapse: collapse;
			margin-top: 20px;
		}

		th,
		td {
			padding: 12px 10px;
			border-bottom: 1px solid #ddd;
			text-align: left;
		}

		th {
			background-color: #f0f0f0;
			color: #333;
			font-weight: bold;
		}

		td a {
			color: #4CAF50;
			text-decoration: none;
			font-weight: bold;
		}

		td a:hover {
			text-decoration: underline;
		}
	</style>
</head>
<body>
	<section>
		<nav>
			<a href="index.php">Início</a>
			<a href="s3.php">Enviar para S3</a>
			<a href="listar.php">Listar Bucket</a>
		</nav>
		<main>
			<h1>
				Arquivos no bucket:
				<?= htmlspecialchars($bucketName) ?>
			</h1>

			<?php if (empty($objects)): ?>
				<p>Nenhum arquivo encontrado.</p>
			<?php else: ?>
				<table>
					<thead>
						<tr>
							<th>Arquivo</th>
							<th>Última Modificação</th>
							<th>Tamanho</th>
							<th>Link</th>
						</tr>
					</thead>
					<tbody>
						<?php foreach ($objects as $obj): ?>
							<tr>
								<td><?= htmlspecialchars($obj['Key']) ?></td>
								<td><?= $obj['LastModified'] ?></td>
								<td><?= round($obj['Size'] / 1024, 2) ?> KB</td>
								<td>
									<?php
										$cmd = $s3->getCommand('GetObject', [
											'Bucket' => $bucketName,
											'Key' => $obj['Key']
										]);
										$request = $s3->createPresignedRequest($cmd, '+10 minutes');
										$presignedUrl = (string) $request->getUri();
									?>
									<a href="<?= htmlspecialchars($presignedUrl) ?>" target="_blank">Abrir</a>
								</td>
							</tr>
						<?php endforeach; ?>
					</tbody>
				</table>
			<?php endif; ?>
		</main>
	</section>
</body>
</html>
EOF


set -e
echo "Configurando Apache com DocumentRoot para /var/www/html/devops..."

# Define o novo DocumentRoot no VirtualHost padrão
CONF_FILE="/etc/httpd/conf/httpd.conf"

# Ajusta as permissões
sudo chown -R apache:apache /var/www/html/devops
sudo chmod -R 755 /var/www/html/devops

# Adiciona ou ajusta o DirectoryIndex
if grep -q "DirectoryIndex" "$CONF_FILE"; then
    sudo sed -i 's/^DirectoryIndex.*/DirectoryIndex index.php index.html/' "$CONF_FILE"
else
    echo "DirectoryIndex index.php index.html" | sudo tee -a "$CONF_FILE"
fi

# Substitui o DocumentRoot padrão, se necessário
sudo sed -i 's|DocumentRoot .*|DocumentRoot /var/www/html/devops|' "$CONF_FILE"
sudo sed -i 's|<Directory \"/var/www/html\">|<Directory \"/var/www/html/devops\">|' "$CONF_FILE"

# Reinicia o Apache
echo "Reiniciando o Apache..."
sudo systemctl restart httpd