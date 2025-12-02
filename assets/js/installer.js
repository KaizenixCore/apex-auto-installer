class ApexInstaller {
    constructor() {
        this.currentStep = 1;
        this.systemInfo = {};
        this.init();
    }

    init() {
        this.detectSystem();
        document.getElementById('btn-next').addEventListener('click', () => this.nextStep());
        document.getElementById('btn-prev').addEventListener('click', () => this.prevStep());
    }

    detectSystem() {
        const platform = navigator.platform.toLowerCase();
        
        let osName = 'نامشخص';
        let osIcon = '❓';
        
        if (platform.includes('win')) {
            osName = 'ویندوز';
            osIcon = '🪟';
            this.systemInfo.os = 'windows';
        } else if (platform.includes('linux')) {
            osName = 'لینوکس';
            osIcon = '🐧';
            this.systemInfo.os = 'linux';
        } else if (platform.includes('mac')) {
            osName = 'مک';
            osIcon = '🍎';
            this.systemInfo.os = 'mac';
        }
        
        let arch = platform.includes('64') ? '64-bit (x86_64)' : '32-bit';
        
        document.getElementById('os-name').textContent = osIcon + ' ' + osName;
        document.getElementById('arch').textContent = '💻 ' + arch;
        
        setTimeout(() => {
            document.getElementById('docker-status').innerHTML = '⚠️ نیاز به بررسی';
        }, 1500);
    }

    nextStep() {
        if (this.currentStep < 4) {
            document.querySelectorAll('.step').forEach(s => s.classList.remove('active'));
            this.currentStep++;
            const names = ['', 'detect', 'select', 'install', 'complete'];
            document.getElementById('step-' + names[this.currentStep]).classList.add('active');
            
            if (this.currentStep === 3) this.startInstallation();
        }
        this.updateButtons();
    }

    prevStep() {
        if (this.currentStep > 1) {
            document.querySelectorAll('.step').forEach(s => s.classList.remove('active'));
            this.currentStep--;
            const names = ['', 'detect', 'select', 'install', 'complete'];
            document.getElementById('step-' + names[this.currentStep]).classList.add('active');
        }
        this.updateButtons();
    }

    updateButtons() {
        document.getElementById('btn-prev').disabled = this.currentStep === 1;
        const btnNext = document.getElementById('btn-next');
        if (this.currentStep === 4) btnNext.style.display = 'none';
        else if (this.currentStep === 2) btnNext.textContent = '🚀 شروع نصب';
        else btnNext.textContent = 'بعدی';
    }

    startInstallation() {
        const steps = [
            '🔍 بررسی پیش‌نیازها...',
            '🐳 بررسی Docker...',
            '📥 دانلود Oracle Database...',
            '⚙️ راه‌اندازی دیتابیس...',
            '📥 دانلود APEX 24.2...',
            '⚙️ نصب APEX...',
            '🌐 راه‌اندازی ORDS...',
            '✨ نصب کامل شد!'
        ];
        
        const log = document.getElementById('install-log');
        log.innerHTML = '';
        let i = 0;
        
        const run = () => {
            if (i >= steps.length) {
                setTimeout(() => this.nextStep(), 1000);
                return;
            }
            const div = document.createElement('div');
            div.className = 'log-item';
            div.textContent = steps[i];
            log.appendChild(div);
            
            const progress = ((i + 1) / steps.length) * 100;
            document.getElementById('progress-fill').style.width = progress + '%';
            document.getElementById('progress-text').textContent = Math.round(progress) + '٪';
            
            i++;
            setTimeout(run, 1500);
        };
        run();
    }
}

document.addEventListener('DOMContentLoaded', () => new ApexInstaller());
