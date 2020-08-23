// 오직 이 프로그램에서만 사용되는 자바스크립트
var $html = $('html');

function MobileTopBar__init() {
	$('.mobile-top-bar .btn-toggle-mobile-side-bar').click(function() {
		$html.toggleClass('mobile-side-bar-actived');
	});
}

$(function() {
	MobileTopBar__init();
})

var nowLoading = false;

function startLoading() {
    nowLoading = true;
    
    $html.addClass('loading-box-actived');
}

function endLoading() {
    nowLoading = false;
    
    $html.removeClass('loading-box-actived');
}

function isNowLoading() {
    return nowLoading;
}

// 아이폰 용 끄기
// 1) Pinch Zoom 끄기
document.documentElement.addEventListener('touchstart', function (event) {
    if (event.touches.length > 1) {
      event.preventDefault();
    }
}, false);

// 아이폰 용 끄기
// Double tab Zoom 끄기
var lastTouchEnd = 0;
document.documentElement.addEventListener('touchend', function (event) {
    var now = (new Date()).getTime();
    if (now - lastTouchEnd <= 300) {
      event.preventDefault();
    }
    lastTouchEnd = now;
}, false);

