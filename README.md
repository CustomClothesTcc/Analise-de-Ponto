<h1>📱 Controle de Funcionários - Projeto Flutter</h1>
<p>
  Este projeto foi desenvolvido utilizando o framework <b>Flutter</b> com o objetivo de fornecer uma ferramenta para gerenciamento de funcionários.  
  Ele permite editar informações de outros aplicativos dos funcionários, como:
</p>
<ul>
  <li>Registro de chegada ao local de trabalho.</li>
  <li>Início do expediente.</li>
  <li>Valores recebidos por obra.</li>
</ul>
<p>
  O sistema foi pensado para integrar dados de diferentes plataformas, com suporte multiplataforma para Android, iOS, Web e Desktop.</p>

<p>
  Este projeto interage diretamente com o aplicativo Java <a href="https://github.com/CustomClothesTcc/Aplicativo-Geofence" target="_blank">Aplicativo Geofence</a>, responsável por rastrear a localização geográfica e o início do expediente.
</p>

---

<h2>🏗️ Arquitetura do Projeto</h2>
<p>
  A estrutura do projeto segue as convenções padrão do Flutter, organizada em múltiplos diretórios para facilitar o desenvolvimento, teste e manutenção.
</p>
<pre>
android/      # Configurações e código nativo para Android.
ios/          # Configurações e código nativo para iOS.
lib/          # Código principal do aplicativo em Flutter (Dart).
linux/        # Configurações e código nativo para Linux.
macos/        # Configurações e código nativo para macOS.
web/          # Configurações para suporte ao navegador.
windows/      # Configurações e código nativo para Windows.
doc/          # Documentação adicional (diagramas, manuais, etc.).
</pre>

---

<h2>📋 Funcionalidades</h2>
<ul>
  <li><b>Edição de Informações:</b> Permite alterar dados como horários de chegada e início de expediente, diretamente sincronizados com o sistema do funcionário.</li>
  <li><b>Gestão de Valores Recebidos:</b> Controle detalhado dos valores pagos por obra ou projeto.</li>
  <li><b>Suporte Multiplataforma:</b> Funciona em dispositivos móveis, navegadores e desktops.</li>
</ul>

---

<h2>🚀 Como Usar</h2>
<ol>
  <li>Clone este repositório:</li>
  <pre>
git clone https://github.com/seu-usuario/Controle_Funcionarios.git
  </pre>
  <li>Acesse o diretório do projeto:</li>
  <pre>
cd Controle_Funcionarios
  </pre>
  <li>Certifique-se de que o <a href="https://flutter.dev/docs/get-started/install">Flutter</a> esteja instalado e configurado no seu ambiente.</li>
  <li>Instale as dependências:</li>
  <pre>
flutter pub get
  </pre>
  <li>Configure o banco de dados MySQL:</li>
  <ul>
    <li>Certifique-se de que o MySQL esteja instalado e em execução.</li>
    <li>Crie o banco de dados e execute o script de criação das tabelas (disponível na pasta <code>doc/</code>).</li>
    <li>Atualize as credenciais de acesso ao banco no arquivo de configuração do projeto.</li>
  </ul>
  <li>Execute o projeto na plataforma desejada:</li>
  <pre>
flutter run
  </pre>
</ol>

---

<h2>🛠️ Tecnologias Utilizadas</h2>
<ul>
  <li><b>Flutter:</b> Framework para desenvolvimento multiplataforma.</li>
  <li><b>Dart:</b> Linguagem de programação utilizada pelo Flutter.</li>
  <li><b>MySQL:</b> Banco de dados relacional utilizado para armazenar e gerenciar informações.</li>
  <li><b>SQLite:</b> Para armazenamento local temporário, se necessário.</li>
  <li><b>Firebase:</b> Opcional para sincronização de dados em tempo real.</li>
  <li><b>Java:</b> Interação com o aplicativo geográfico <a href="https://github.com/CustomClothesTcc/Aplicativo-Geofence" target="_blank">Aplicativo Geofence</a>.</li>
</ul>

---

<h2>📑 Documentação</h2>
<p>
  O diretório <code>doc/</code> contém materiais adicionais para facilitar o entendimento e a manutenção do projeto, incluindo:
</p>
<ul>
  <li>Diagramas de casos de uso.</li>
  <li>Manuais de configuração e operação.</li>
  <li>Script SQL para criação do banco de dados e tabelas.</li>
  <li>Especificações técnicas do sistema.</li>
</ul>

