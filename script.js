// 平滑滚动功能
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        
        const targetId = this.getAttribute('href');
        const targetElement = document.querySelector(targetId);
        
        window.scrollTo({
            top: targetElement.offsetTop - 80,
            behavior: 'smooth'
        });
    });
});

// 添加滚动时的视觉效果
window.addEventListener('scroll', function() {
    const header = document.querySelector('.header');
    if (window.scrollY > 50) {
        header.style.boxShadow = '0 4px 12px rgba(0, 0, 0, 0.08)';
        header.style.background = 'rgba(255, 255, 255, 0.98)';
    } else {
        header.style.boxShadow = '0 1px 3px rgba(0, 0, 0, 0.1)';
        header.style.background = 'rgba(255, 255, 255, 0.95)';
    }
});

// 导航栏滚动效果
window.addEventListener('scroll', function() {
    const header = document.querySelector('.header');
    if (window.scrollY > 100) {
        header.style.boxShadow = '0 4px 20px rgba(0, 0, 0, 0.1)';
        header.style.background = 'rgba(255, 255, 255, 0.95)';
    } else {
        header.style.boxShadow = '0 4px 6px rgba(0, 0, 0, 0.1)';
        header.style.background = 'white';
    }
});

// 表单提交处理
const contactForm = document.querySelector('.contact-form form');
if (contactForm) {
    contactForm.addEventListener('submit', function(e) {
        e.preventDefault();
        
        // 获取表单数据
        const name = this.querySelector('input[type="text"]').value;
        const email = this.querySelector('input[type="email"]').value;
        const message = this.querySelector('textarea').value;
        
        // 简单验证
        if (name && email && message) {
            // 显示成功消息
            const originalText = this.querySelector('button[type="submit"]').textContent;
            this.querySelector('button[type="submit"]').textContent = '发送中...';
            this.querySelector('button[type="submit"]').disabled = true;
            
            // 模拟发送过程
            setTimeout(() => {
                alert('感谢您的留言！我们会尽快回复您。');
                this.querySelector('button[type="submit"]').textContent = originalText;
                this.querySelector('button[type="submit"]').disabled = false;
                // 重置表单
                this.reset();
            }, 1500);
        } else {
            alert('请填写所有必填字段。');
        }
    });
}

// 动画效果初始化
document.addEventListener('DOMContentLoaded', function() {
    // 为特性卡片添加进入视口动画
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach((card, index) => {
        // 添加延迟以创建级联效果
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        
        setTimeout(() => {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.1 });
            
            observer.observe(card);
        }, index * 100);
    });
    
    // 为生态系统卡片添加进入视口动画
    const ecosystemCards = document.querySelectorAll('.ecosystem-card');
    ecosystemCards.forEach((card, index) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(20px)';
        card.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        
        setTimeout(() => {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateY(0)';
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.1 });
            
            observer.observe(card);
        }, index * 100);
    });
    
    // 为时间线项添加进入视口动画
    const timelineItems = document.querySelectorAll('.timeline-item');
    timelineItems.forEach((item, index) => {
        item.style.opacity = '0';
        item.style.transform = 'translateX(' + (index % 2 === 0 ? '-' : '') + '20px)';
        item.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        
        setTimeout(() => {
            const observer = new IntersectionObserver((entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.style.opacity = '1';
                        entry.target.style.transform = 'translateX(0)';
                        observer.unobserve(entry.target);
                    }
                });
            }, { threshold: 0.1 });
            
            observer.observe(item);
        }, index * 150);
    });
});

// 代码高亮效果（简化版本）
document.addEventListener('DOMContentLoaded', function() {
    const codeBlocks = document.querySelectorAll('pre code');
    codeBlocks.forEach(block => {
        // 添加基本的语法高亮类
        const code = block.textContent;
        
        // 简化的关键字高亮
        const highlightedCode = code
            .replace(/\b(const|let|var|function|return|if|else|for|while|new)\b/g, '<span class="keyword">$1</span>')
            .replace(/(\.run|\.config|\.modules)/g, '<span class="method">$1</span>')
            .replace(/(".*?"|'.*?')/g, '<span class="string">$1</span>')
            .replace(/(\/\/.*)/g, '<span class="comment">$1</span>');
        
        block.innerHTML = highlightedCode;
    });
});

// 添加悬停效果到特性卡片
document.addEventListener('DOMContentLoaded', function() {
    const featureCards = document.querySelectorAll('.feature-card');
    featureCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
    
    // 添加悬停效果到生态系统卡片
    const ecosystemCards = document.querySelectorAll('.ecosystem-card');
    ecosystemCards.forEach(card => {
        card.addEventListener('mouseenter', function() {
            this.style.transform = 'translateY(-5px)';
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = 'translateY(0)';
        });
    });
});