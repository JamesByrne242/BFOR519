# BFOR519
Final project

Overview:
This is a ransomware similation, utilizing LOLBIN (PowerShell) in an attempt to learn more about the general flow on an attack.
The script will be ran in a controlled homelab environment, where I will recover the servers and workstations to their original states prior to the attack.
I will create an incident response plan to govern this process and review the event viewer logs in an attempt to learn more about the indicators of compromise.

Relevance:
This project is relevant to the field of cybersecurity because it focuses on upholding the ideals of confidentiality, integrity, and availability. Following an incident response plan
and being able to recover systems effectively are vital to increasing uptime and ensuring the overall operating success of systems.

Methodology:
The environment consists of a workstation, a domain controller, a hypervisor, and 2 network drives to be used in this exercise. The "important data" will be denoted by text files located.
The initial threat vector will be an email that will simulate a user triggering a malicious script that will convert .txt documents on the infected workstation and network drives that are hosted on the Domain Controller.
Checkpoints will be set with

Results:
I have event viewer log exports to show time correlation in order to properly recover the environment to a safe state.
Included in this repository is a folder for "logs" and a folder for "screenshots" for further informtaion.

Conclusion and Key Insights:
- The incident response plan should always grow and evolve to encompass an organizations needs.
- Proper segmentation is essential.
- Following the principle of least privilege could have mitigated this attack.
- The weakest link is oftentimes the users themselves, so it is important to train employees accordingly.
- Recovery time is dependent on following the response plan and how quickly the attack can be isolated and quarantined.
