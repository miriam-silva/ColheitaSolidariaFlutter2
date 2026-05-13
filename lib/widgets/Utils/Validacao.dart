class Validacao {
  static String limparNumero(String valor) {
    return valor.replaceAll(RegExp(r'[^0-9]'), '');
  }

  static String? validarNome(String? nome) {
    if (nome == null || nome.trim().isEmpty) {
      return "Nome obrigatório";
    }

    final nomeLimpo = nome.trim();

    if (nomeLimpo.split(" ").length < 2) {
      return "Digite nome e sobrenome";
    }

    if (RegExp(r'[0-9]').hasMatch(nomeLimpo)) {
      return "O nome não pode conter números";
    }

    if (RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(nomeLimpo)) {
      return "O nome não pode conter caracteres especiais";
    }

    return null;
  }

  static String? validarCPF(String? cpf) {
    if (cpf == null || cpf.isEmpty) {
      return "CPF obrigatório";
    }

    cpf = limparNumero(cpf);

    if (cpf.length != 11) {
      return "CPF inválido";
    }

    return null;
  }

  static String? validarCNPJ(String? cnpj) {
    if (cnpj == null || cnpj.isEmpty) {
      return "CNPJ obrigatório";
    }

    cnpj = limparNumero(cnpj);

    if (cnpj.length != 14) {
      return "CNPJ inválido";
    }

    return null;
  }

  static String? validarEmail(String? email) {
    if (email == null || email.isEmpty) {
      return "E-mail obrigatório";
    }

    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!regex.hasMatch(email)) {
      return "E-mail inválido";
    }

    return null;
  }

  static String? validarTelefone(String? telefone) {
    if (telefone == null || telefone.isEmpty) {
      return "Telefone obrigatório";
    }

    telefone = limparNumero(telefone);

    // celular: 11999999999
    // fixo: 1133334444

    if (telefone.length != 10 && telefone.length != 11) {
      return "Telefone deve conter DDD e número";
    }

    if (!RegExp(r'^[0-9]+$').hasMatch(telefone)) {
      return "Telefone inválido";
    }

    final ddd = int.tryParse(telefone.substring(0, 2));

    if (ddd == null || ddd < 11 || ddd > 99) {
      return "DDD inválido";
    }

    return null;
  }

  static String? validarEndereco(String? endereco) {
    if (endereco == null || endereco.trim().isEmpty) {
      return "Endereço obrigatório";
    }

    final enderecoLimpo = endereco.trim();

    if (enderecoLimpo.length < 8) {
      return "Endereço muito curto";
    }

    if (!enderecoLimpo.contains(",")) {
      return "Separe rua, número e bairro usando vírgulas";
    }

    final partes = enderecoLimpo
        .split(",")
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();

    if (partes.length < 2) {
      return "Informe pelo menos rua e número ou bairro";
    }

    bool possuiNumero = RegExp(r'\d').hasMatch(enderecoLimpo);

    if (!possuiNumero) {
      return "Informe o número da residência";
    }

    return null;
  }

  static String? validarSenha(String? senha) {
    if (senha == null || senha.isEmpty) {
      return "Senha obrigatória";
    }

    if (senha.length < 6) {
      return "A senha deve ter pelo menos 6 caracteres";
    }

    if (!RegExp(r'[A-Z]').hasMatch(senha)) {
      return "A senha deve conter uma letra maiúscula";
    }

    if (!RegExp(r'[a-z]').hasMatch(senha)) {
      return "A senha deve conter uma letra minúscula";
    }

    if (!RegExp(r'[!@#\$%^&*(),.?":{}|<>]').hasMatch(senha)) {
      return "A senha deve conter um caractere especial";
    }

    return null;
  }

  static String? validarConfirmacaoSenha(String senha, String confirmarSenha) {
    if (confirmarSenha.isEmpty) {
      return "Confirme sua senha";
    }

    if (senha != confirmarSenha) {
      return "As senhas não coincidem";
    }

    return null;
  }

  static String? validarIdade(String? dataNascimento) {
    if (dataNascimento == null || dataNascimento.isEmpty) {
      return "Data de nascimento obrigatória";
    }

    try {
      final partes = dataNascimento.split("/");

      final data = DateTime(
        int.parse(partes[2]),
        int.parse(partes[1]),
        int.parse(partes[0]),
      );

      final hoje = DateTime.now();

      int idade = hoje.year - data.year;

      if (hoje.month < data.month ||
          (hoje.month == data.month && hoje.day < data.day)) {
        idade--;
      }

      if (idade < 18) {
        return "É necessário ter pelo menos 18 anos";
      }

      return null;
    } catch (e) {
      return "Data inválida";
    }
  }
}
