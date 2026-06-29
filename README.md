# COMP 2137 F25 - Linux Automation Portfolio

This repository serves as a portfolio of my work for the **COMP 2137 - Linux Automation** course. This course focuses on developing essential administrative scripting and system automation skills within a Linux environment.

The projects within showcase my ability to leverage the command line and various configuration management tools to streamline complex IT operations, preparing me for a career in Systems Administration or DevOps.

---

## 🚀 Key Learning Outcomes & Skills Displayed

### Scripting and Core Linux
* **Shell Scripting (Bash):** Writing, debugging, and deploying robust scripts to automate routine, repetitive system administration tasks.
* **Data and Log Management:** Accessing, manipulating, and filtering system data, logs, and process information using shell utilities and custom scripts.
* **System Diagnostics:** Developing scripts to measure system performance metrics (CPU, memory, disk I/O) and generate actionable reports.
* **Troubleshooting:** Implementing methodical testing and debugging to ensure script reliability and validate system modifications.

### Modern Automation (Configuration Management)
* **Infrastructure as Code (IaC):** Applying formula-based configuration management principles to automate system setup and maintenance.
* **Configuration Tools:** Practical experience using popular industry tools like **Puppet, Ansible, and Chef** to manage and configure Linux hosts at scale.

---

## 📂 Scripts

### Featured: `configure-host.sh`
An **idempotent** host-configuration script that sets the system hostname, assigns a
static IP via netplan, and manages `/etc/hosts` entries — all driven by command-line
arguments (`-name`, `-ip`, `-hostentry`, `-verbose`). It only changes what isn't already
correct, backs up the netplan file before editing, logs every change via `logger`,
enforces a root check, and validates its arguments. Demonstrates configuration-management
fundamentals in pure Bash.

### `system_report.sh`
Generates a formatted system report: OS, uptime, CPU, RAM, disk, gateway/DNS, logged-in
users, process count, load averages, listening ports, and UFW firewall status.

### Foundational exercises
| Script | What it does |
|---|---|
| `system_id.sh` | Prints hostname, IP address, and uptime |
| `software_update.sh` | Runs `apt update` and `apt upgrade -y` |
| `helloworld.sh` | First Bash script — scripting fundamentals |             

---

## 💡 Technical Environment

* All work is developed and tested within **Ubuntu** virtual machine environments.
* Projects utilize standard Linux command-line utilities and administrative scripting languages.
* Demonstrations of configuration management use free, open-source versions of the specified tools.
