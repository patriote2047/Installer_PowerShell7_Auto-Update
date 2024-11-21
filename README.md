# 🚀 Script d'Installation PowerShell 7

[![PowerShell](https://img.shields.io/badge/PowerShell-7-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Windows](https://img.shields.io/badge/Windows-7%2B-brightgreen.svg)](https://www.microsoft.com/windows)
[![Maintenance](https://img.shields.io/badge/Maintained%3F-yes-green.svg)](https://github.com/your/repo)
[![License](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/)

> 🔧 Ce script automatise l'installation de PowerShell 7 sur Windows avec des fonctionnalités avancées de vérification et de configuration.

---

## ✨ Fonctionnalités

- 🛡️ Vérification automatique des privilèges administrateur
- 🔍 Détection de l'installation existante de PowerShell 7
- ⬇️ Téléchargement automatique de la dernière version stable depuis GitHub
- ⚙️ Installation silencieuse avec options optimisées
- 🔄 Configuration automatique du PATH système
- 📝 Support de l'encodage UTF-8
- 🎨 Interface utilisateur avec retours visuels colorés

![Capture d'écran](screenshot.png)

## 📋 Prérequis

| Composant | Version/Détail |
|-----------|---------------|
| 💻 Windows | 7 ou supérieur |
| 👑 Droits | Administrateur |
| 🌐 Internet | Connexion requise |

## 📖 Utilisation

1. 📥 Exécutez le script `Install-PowerShell7.ps1`
2. 🛡️ Si nécessaire, le script demandera automatiquement les privilèges administrateur
3. 🔍 Le script vérifiera si PowerShell 7 est déjà installé
4. ❓ Si une installation est nécessaire, une confirmation sera demandée
5. ⚙️ L'installation se déroulera automatiquement avec retours visuels
6. 🔄 Une fois terminé, redémarrez votre terminal pour utiliser PowerShell 7

## 📥 Installation depuis GitHub

### Méthode rapide (PowerShell)

```powershell
# Télécharger et exécuter directement (Non recommandé pour la sécurité)
irm https://raw.githubusercontent.com/patriote2047/Install-PowerShell7/main/Install-PowerShell7.ps1 | iex
```

### Méthode sécurisée (Recommandée)

1. 📥 Cloner le dépôt
```powershell
git clone https://github.com/patriote2047/Install-PowerShell7.git
cd Install-PowerShell7
```

2. 🔍 Vérifier le contenu du script (optionnel mais recommandé)
```powershell
code Install-PowerShell7.ps1  # ou notepad Install-PowerShell7.ps1
```

3. ▶️ Exécuter le script
```powershell
.\Install-PowerShell7.ps1
```

> ⚠️ **Note de sécurité** : Il est toujours recommandé de vérifier le contenu d'un script avant de l'exécuter.

## ⚙️ Options d'Installation

Le script configure automatiquement :
- 📂 Menu contextuel dans l'Explorateur Windows
- 🔌 PowerShell Remoting
- 📝 Enregistrement du manifeste système
- 🔄 Variables d'environnement PATH

## 🔧 Dépannage

| Problème | Solution |
|----------|----------|
| ❌ Échec de l'installation | Vérifiez vos droits administrateur |
| 🌐 Erreur de téléchargement | Vérifiez votre connexion Internet |
| 🔄 PowerShell absent du PATH | Redémarrez votre terminal |

## 👤 Auteur

**Cascade** - 2024

<div align="center">

### 🌟 N'hésitez pas à utiliser et partager ce script ! 🌟

</div>

## 📜 Licence

Ce script est fourni tel quel, sans garantie. Utilisez-le à vos propres risques.

---

<div align="center">

[![Made with ❤️](https://img.shields.io/badge/Made%20with-%E2%9D%A4%EF%B8%8F-red.svg)](https://github.com/your/repo)

</div>
