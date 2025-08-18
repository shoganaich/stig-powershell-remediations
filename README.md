<img width="1584" height="396" alt="Copy of Black Gradient Minimalist Corporate Business Personal Profile New LinkedIn Banner" src="https://github.com/user-attachments/assets/fe8e5048-aa4e-445f-a0a6-432f2c8546a7" />

# DISA STIG PowerShell Remediations
![PowerShell](https://img.shields.io/badge/PowerShell-7%2B-blue)
![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)
![Status](https://img.shields.io/badge/Project-Internship%20Demo-lightgrey)
![Last Commit](https://img.shields.io/github/last-commit/shoganaich/stig-powershell-remediations)

PowerShell scripts to help automate **DISA STIG compliance remediations** for Windows systems.  

>📌 **Important Note**:
>This repository was created during an **internship project** as part of a learning and practical exercise.  
>It is **not a large-scale professional open-source project** like 7-Zip or other enterprise-grade tools.  
>Instead, it is a pack of useful scripts that may assist administrators or learners working with STIG compliance.  

---

## Requirements
- Windows PowerShell **5+**
- **Administrative privileges**
- Tested on **Windows 10 22H2**
- Access to relevant **DISA STIG benchmark files** for reference
---

## Usage

1. **Clone this repository**
   ```powershell
   git clone https://github.com/shoganaich/stig-powershell-remediations
   cd stig-powershell-remediations
   ```

2. **Review the scripts**  
   Each script targets a specific STIG rule or set of rules. Review them before running in production.

3. **Run a remediation**
   ```powershell
   .\remediation-STIG-(XXXXXXXXXXXXXXXXXXX).ps1
   ```
---

## Notes
- Always **test in a non-production environment** before applying changes to production systems.
- Some STIG rules may require manual validation or additional tools.
- Refer to the official [DISA STIG site](https://www.cyber.mil/stigs/) for the latest guidance.

---

## License
This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

## Disclaimer
This repository is provided as-is, without any warranty.
These scripts were created during an internship as a learning and demonstration project.
They are not guaranteed to cover all STIG rules or be fully production-ready.
Use them as a reference or baseline, and customize/validate for your specific environment.
