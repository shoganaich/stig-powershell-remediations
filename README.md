# DISA STIG PowerShell Remediations

PowerShell scripts to automate DISA STIG compliance remediations for Windows systems.  
This repository provides a set of scripts designed to help administrators quickly apply required security configurations and maintain compliance with Department of Defense (DoD) standards.

--- 

## Requirements
- Windows PowerShell 5.1 or PowerShell 7+
- Administrative privileges
- Tested on Windows 10 / 11
- Access to relevant DISA STIG benchmark files for reference

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
   .\Remediate-STIG-XXXXXXXXXXXXXXXXXXXXX.ps1
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
This repository is provided as-is, without any warranty. The scripts are intended as a starting point and may need customization for your specific environment.
