// landing

const landing = document.getElementById("landing");
addEventListener("scroll", () => {
	if (scrollY < landing.offsetHeight) {
		landing.style.setProperty("--scroll", scrollY / 2 + "px");
	}
});

// screenshots

const marqueeTop = document.getElementById("marquee-top");
const marqueeBottom = document.getElementById("marquee-bottom");
let topX = 0, bottomX = marqueeTop.clientWidth - marqueeTop.scrollWidth;
let delta = 1;
setInterval(() => {
	topX -= delta, bottomX += delta;
	marqueeTop.firstElementChild.style.marginLeft = topX + "px";
	marqueeBottom.firstElementChild.style.marginLeft = bottomX + "px";
	if (topX >= 0) delta = Math.abs(delta) * 1;
	else if (marqueeTop.scrollWidth - marqueeTop.clientWidth <= 0) delta = Math.abs(delta) * -1;
}, 10);

marqueeTop.addEventListener("scroll");