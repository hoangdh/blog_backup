$(document).ready(function(){
    $body = $( 'body' );
    $body.wrapInner("<div class='body-inner'></div>");
          $("<a href='#' class='btn-navbar btn-navbar-navtoggle btn-flyout-trigger'><i class='fa fa-list-ul'></i></a>").insertBefore(".navbar-header");
          $("#search-navbar-collapse").append("<div class='searchCopy'><a href='#' class='fa fa-search'></a><a href='#' class='fa fa-close'></a></div>");
          $(function(){
                  faSearch = $(".searchCopy > a.fa-search"),
                  faClose = $(".searchCopy > a.fa-close");
                  //When click faSearch then hide faClose
                  faSearch.click(function(){
                          $("#search-navbar-collapse").parent().addClass("search-wrap");
                          });
                  faClose.click(function(){
                          $("#search-navbar-collapse").parent().removeClass("search-wrap");	
                          });
          });
    $.cbFlyNav = function( options, element ) {
                  this.$el = $( element );
                  this._init( options );
          };
    $.cbFlyNav.defaults = {
      trigger: '.btn-flyout-trigger'
      ,cbNavWrapper: 'body'
      ,cbContentWrapper: '.body-inner'
      ,minWidth: 800
          };
    //menu responsive when click trigger btn
    $.cbFlyNav.prototype = {
      _init : function( options ) {
        this.options = $.extend({}, $.cbFlyNav.defaults, options);

        //Cache elements and intit variables
        this._config();

        //Initialize event listenters
        this._initEvents();
      },

      _config : function() {
                          this.open = false;
        this.copied = false;
        this.windowWith = $(window).width();
        this.subNavOpen = false;
        this.wasOpened = false;
        this.$cbWrap = $('<div class="cbFlyNav-wrap"></div>');
        this.$trigger = $(this.options.trigger);
        this.$regMenus = this.$el.children( 'ul.nav.nav-pill' );
        this.$newMenus = $(this.$el.clone());
        this.$contentMask = $('<a class="nav-flyout-contentmask" href="#"></a>');
        this.$navMask = $('<a class="nav-flyout-navmask" href="#"></a>');
        this.$openSubnav = "";
                  },

      _initEvents : function() {
        var self = this; 
                          var titleIcon = $(".cbFlyNav-wrap .navbar-nav li > a").attr("title");
        self.$trigger.on('click.cbFlyNav', function(e) {
          e.stopPropagation();
          if ( !self.open ) {
            if ( !self.copied ) {
              self._copyNav();
                                                  $body.find(".navbar-brand").clone().insertBefore(".cbFlyNav-wrap .navbar-nav");
                                                  $("<i class='fa fa-caret-square-o-right'></i>").insertBefore(".cbFlyNav-wrap .navbar-nav li > a[title='Phim ngắn']");
                                                  $("<i class='fa fa-smile-o'></i>").insertBefore(".cbFlyNav-wrap .navbar-nav li > a[title='Phim hài']");
                                                  $("<i class='fa fa-smile-o'></i>").insertBefore(".cbFlyNav-wrap .navbar-nav li > a[title='Clip hài']");
                                                  $("<i class='fa fa-caret-square-o-right'></i>").insertBefore(".cbFlyNav-wrap .navbar-nav li > a[title='Thiếu Nhi']");
            }
            self._openNav(); 
          }
          else {
            self._closeNav();
          }
          self.wasOpened = true;
          //console.log('WasOpened: '+self.wasOpened+ '. Open? '+self.open);
        });

        //Hide menu when window is bigger than allowed minWidth
        $(window).on('resize', function() {
          var windowWidth = $(window).width();
          if(self.open && windowWidth > self.options.minWidth){
            self._closeNav();
          }
        });

        //Hide menu when body clicked. Usign an a tag to mask content.
        self.$contentMask.on('click.cbFlyNav', function( e ) {
          e.preventDefault();
          self._closeNav();
        });

        self.$navMask.on('click.cbFlyNav', function( e ) {
          e.preventDefault();
          self._closeSubNav();
        });

        //Handle clicks inside menu
        self.$newMenus.on( 'click.cbFlyNav', function( e ) {
          e.stopPropagation();
          var $menu = $(this);
          //console.log("Menu clicked");
        });

        //Handle menu item clicks
        self.$newMenus.children().find('li').on('click.cbFlyNav', function(e) {
          e.stopPropagation();
          var $item = $(this),
              $subnav = $item.find('ul.subnav');

          if ($subnav.length > 0) {
            //item with subnav clicked

            //console.log("Item with subnav clicked");

            $subnav.css('height', window.innerHeight);
            self._openSubNav($subnav);
          }
          else {
            //item without subnav clicked
            //console.log("Item without subnav clicked");
          }
        });

      },
      _copyNav : function() {
        var self = this;
        console.log("copying nav");
        var newWrap = $('<div class="cbFlyNav-wrap"></div>');
        self.$newMenus.children( 'ul.nav.nav-pill' ).each(function() {
          $this = $(this);
          $this.removeClass('nav-pill').addClass('nav-flyout');
          $this.find('.caret').replaceWith('<i class="icon-cbmore"></i>')
        });

        $(self.options.cbNavWrapper).prepend(self.$cbWrap.prepend(self.$newMenus));
        self.copied = true;

      },

      openNav : function() {
        if ( !this.open ) {
          this._openNav();
        }
      },

      _openNav : function() {
        var self = this;
        console.log("Opening Nav");

        $(self.options.cbNavWrapper).addClass('isCbFlyNavActive');
        $(self.options.cbContentWrapper)
                          .addClass('isCbFlyNavActive')
                          .append(self.$contentMask);

        self.open = true;
      },

      closeNav : function() {
        if ( !this.close ) {
          this._closeNav();
        }
      },

      _closeNav : function() {
        var self = this;
        console.log("Closing Nav");

        $(self.options.cbNavWrapper).removeClass('isCbFlyNavActive');
        $(self.options.cbContentWrapper).removeClass('isCbFlyNavActive');

        if(self.subNavOpen) {
          self._closeSubNav();
        }
        self.$contentMask.detach();

        self.open = false;
      },

      _openSubNav : function($subnav) {
        var self = this,
            $parent = $subnav.parent('li');

        $subnav.addClass('is-subnav-visible');
        $parent.addClass('is-active');
        self.$newMenus.addClass('is-inactive');
        self.$cbWrap.append(self.$navMask);

        $subnav.on('click.cbFlyNav', function(e) {
          e.stopPropagation();
        });

        self.$openSubnav = $subnav;
        self.subNavOpen = true;
      },

      _closeSubNav : function() {
        var self = this,
            $parent = self.$openSubnav.parent('li');

        self.$openSubnav.removeClass('is-subnav-visible');
        $parent.removeClass('is-active');
        self.$newMenus.removeClass('is-inactive');
        self.$navMask.detach();

        self.$openSubnav.off('click.cbFlyNav');

        self.$openSubnav = "";
        self.subNavOpen = false;
      }
    };


    $.fn.cbFlyout = function ( options ) {
      this.each(function() {	
        var instance = $.data( this, 'cbFlyout' );
        if ( instance ) {
          instance._init();
        }
        else {
          instance = $.data( this, 'cbFlyout', new $.cbFlyNav( options, this ) );
        }
      });

      return this;
    }
  
    
          $('#header-wrap .navbar-nav').cbFlyout();
        $(".navbar-nav").find("li.dropdown > a").append("<i class='fa fa-caret-down'></i>");
	$("li.dropdown").mouseover(function(){
		$(this).addClass("open");
	});
        
	$("li.dropdown").mouseleave(function(){
		$(this).removeClass("open");
	});
        
        // Page
        $("button.mm-btn-load-more").click(function()
        {
        	return;
                // get cac thong tin trang co ban
		var page_cur = $(this).attr('_page_cur');
                var per_page = $(this).attr('_per_page');
                var url      = $(this).attr('_url');
                var row_next = parseInt(per_page) + parseInt(page_cur);
                $.ajax({
                            type: 'get',
                            url: url,
                            data: {
                                    "ajax_page" : true,
                                    "per_page" : row_next,
                                    "page_cur" : page_cur,
                            },
                                    beforeSend: function (){
                                            $('button.mm-btn-load-more').hide();
                                            $('#loader').show();
                                            
                                    },
                                    success: function (respone)
                                    {
                                            if(respone == 'disabled')
                                            {
                                                    $('button.mm-btn-load-more').show();
                                                    $('button.mm-btn-load-more').attr('disabled' , 'disabled');
                                                    $('#loader').hide();
                                            }
                                            else
                                            {       
                                                    // ScrollTop
                                                    $("html, body").animate({scrollTop: $(".mm-load-more").offset().top}, 500);

                                                    $('button.mm-btn-load-more').show();
                                                    $('#loader').hide();
                                                    $("#result").append(respone);

                                                    // Cap nhat page hien tai
                                                    $('button.mm-btn-load-more').attr('_per_page', row_next);
                                            }
                                    }
                });

	});
        
        //Show more and show less
	$("button.mm-btn-show-more").click(function(){
		$(".mm-btn-show-less").addClass("show-more");
		$("#watch-description-text").addClass("show-height");
		$(this).removeClass("show-more");
	});
        
	$("button.mm-btn-show-less").click(function(){
		$(".mm-btn-show-more").addClass("show-more");
		$("#watch-description-text").removeClass("show-height");
		$(this).removeClass("show-more");
	});
        
        resizeIframe();
        $(window).resize(function() 
        {
                resizeIframe()
        });
        
        /*
         * Resize iframe
         */
        function resizeIframe()
        {
                var w = $(".iframe-video-details").width(); 
                if(w < 750)
                {
                    var h = 0.61 * w;
                    if(w < 480)
                    {
                            // An breadcrumb
                             $("#mm-breadcrumb").hide();
                    }
                    $(".iframe-video-details iframe").css("width", w);
                    $(".iframe-video-details iframe").css("height", h);
                }
        }
});