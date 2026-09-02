import './style.css';

// Dynamically inject the Navigation Bar to all pages for easy maintenance
const navHTML = `
  <a href="/index.html" class="logo">RoRDB</a>
  <nav>
    <div class="dropdown-toggle" tabindex="0">選單 ▼</div>
    <ul id="nav-links">
      <li><a href="/index.html">首頁</a></li>
      <li><a href="/card-upgrade.html">卡片升星查詢</a></li>
      <li><a href="/promotion-budget.html">升格預算計算</a></li>
      <li><a href="/enchant-conversion.html">附魔轉換表</a></li>
      <li><a href="/pet-combo.html">寵物合體技</a></li>
      <li><a href="/block-puzzle.html">積木大作戰 <span style="background: #e53935; color: #fff; font-size: 11px; padding: 2px 6px; border-radius: 10px; margin-left: 4px; font-weight: bold;">限時</span></a></li>
    </ul>
  </nav>
`;

document.addEventListener("DOMContentLoaded", () => {
  const header = document.createElement('header');
  header.innerHTML = navHTML;
  document.body.prepend(header);

  // Highlight active link
  const currentPath = window.location.pathname;
  const links = document.querySelectorAll('#nav-links a');
  links.forEach(link => {
    const href = link.getAttribute('href');
    if (href === currentPath || (currentPath === '/' && href === '/index.html') || (href && currentPath.endsWith(href))) {
      link.classList.add('active');
    }
  });
});
