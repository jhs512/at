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
