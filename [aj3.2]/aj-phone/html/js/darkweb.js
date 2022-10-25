var CurrentDarkwebTab = "darkweb-home"
var HashtagOpen = false;
var MinimumTrending = 100;

$(document).on('click', '.darkweb-header-tab', function(e){
    e.preventDefault();

    var PressedDarkwebTab = $(this).data('darkwebtab');
    var PreviousDarkwebTabObject = $('.darkweb-header').find('[data-darkwebtab="'+CurrentDarkwebTab+'"]');

    if (PressedDarkwebTab !== CurrentDarkwebTab) {
        $(this).addClass('selected-darkweb-header-tab');
        $(PreviousDarkwebTabObject).removeClass('selected-darkweb-header-tab');

        $("."+CurrentDarkwebTab+"-tab").css({"display":"none"});
        $("."+PressedDarkwebTab+"-tab").css({"display":"block"});

        if (PressedDarkwebTab === "darkweb-mentions") {
            $.post('https://aj-phone/ClearMentions-dark');
        }

        if (PressedDarkwebTab == "darkweb-home") {
            $.post('https://aj-phone/GetAnons', JSON.stringify({}), function(Anons){
                QB.Phone.Notifications.LoadAnons(Anons);
            });
        }

        CurrentDarkwebTab = PressedDarkwebTab;

        if (HashtagOpen) {
            event.preventDefault();

            $(".darkweb-hashtag-anons").css({"left": "30vh"});
            $(".darkweb-hashtags").css({"left": "0vh"});
            $(".darkweb-new-anon").css({"display":"block"});
            $(".darkweb-hashtags").css({"display":"block"});
            HashtagOpen = false;
        }
    } else if (CurrentDarkwebTab == "darkweb-hashtags" && PressedDarkwebTab == "darkweb-hashtags") {
        if (HashtagOpen) {
            event.preventDefault();

            $(".darkweb-hashtags").css({"display":"block"});
            $(".darkweb-hashtag-anons").animate({
                left: 30+"vh"
            }, 150);
            $(".darkweb-hashtags").animate({
                left: 0+"vh"
            }, 150);
            HashtagOpen = false;
        }
    } else if (CurrentDarkwebTab == "darkweb-home" && PressedDarkwebTab == "darkweb-home") {
        event.preventDefault();

        $.post('https://aj-phone/GetAnons', JSON.stringify({}), function(Anons){
            QB.Phone.Notifications.LoadAnons(Anons);
        });
    } else if (CurrentDarkwebTab == "darkweb-mentions" && PressedDarkwebTab == "darkweb-mentions") {
        event.preventDefault();

        $.post('https://aj-phone/GetMentionedAnons', JSON.stringify({}), function(MentionedAnons){
            QB.Phone.Notifications.LoadMentionedAnons(MentionedAnons)
        })
    }
});

$(document).on('click', '.darkweb-new-anon', function(e){
    e.preventDefault();
    ClearInputNew()
    $('#ann-box-textt').fadeIn(350);
});

$(document).on('click', '#ann-sendmessage-chat', function(e){
    e.preventDefault();

    var AnonMessage = $(".ann-box-textt-input").val();
    var imageURL = $('#anon-new-url').val()
    if (AnonMessage != "") {
        var CurrentDate = new Date();
        $.post('https://aj-phone/PostNewAnon', JSON.stringify({
            Message: AnonMessage,
            Date: CurrentDate,
            Picture: "default",
            url: imageURL
        }), function(Anons){
            QB.Phone.Notifications.LoadAnons(Anons);
            ClearInputNew();
            $('#ann-box-textt').fadeOut(350);
        });
        $.post('https://aj-phone/GetHashtags-dark', JSON.stringify({}), function(Hashtags){
            QB.Phone.Notifications.LoadHashtags_dark(Hashtags)
        })
        QB.Phone.Animations.TopSlideUp(".darkweb-new-anon-tab", 450, -120);
    } else {
        QB.Phone.Notifications.Add("fab fa-darkweb", "Darkweb", "Fill a message!", "#1DA1F2");
    };
    $('#anon-new-url').val("");
});

$(document).on('click', '#take-pic2', function (e) {
    e.preventDefault();
    $.post('https://aj-phone/TakePhoto', JSON.stringify({}),function(url){
        if(url){
            $('#anon-new-url').val(url)
        }
    })
    QB.Phone.Functions.Close();
})

QB.Phone.Notifications.LoadAnons = function(Anons) {
    Anons = Anons.reverse();
    if (Anons !== null && Anons !== undefined && Anons !== "" && Anons.length > 0) {
        $(".darkweb-home-tab").html("");
        $.each(Anons, function(i, Anon){
            var clean = DOMPurify.sanitize(Anon.message , {
                ALLOWED_TAGS: [],
                ALLOWED_ATTR: []
            });
            if (clean == '') clean = 'Hmm, I shouldn\'t be able to do this...'
            var AnnMessage = QB.Phone.Functions.FormatDarkwebMessage(clean);
            var TimeAgo = moment(Anon.date).format('MM/DD/YYYY hh:mm');

            var DarkwebHandle = Anon.firstName + ' ' + Anon.lastName
            var PictureUrl = "./img/default.png"
            if (Anon.picture !== "default") {
                PictureUrl = Anon.picture
            }
            if (Anon.anon != null){
                if (Anon.url == "") {
                    let AnonElement = '<div class="darkweb-anon" data-anncid="'+Anon.citizenid+'" data-annid ="'+Anon.anonId+'" data-annhandler="@Anon-' + Anon.anon+ '"><div class="anon-reply"><i class="fas fa-reply"></i></div>' +
                        '<div class="anon-anony">' + 'Anon-' + Anon.anon + ' &nbsp;<span>' + TimeAgo + '</span></div>' +
                        '<div class="anon-message">' + AnnMessage + '</div>' +
                        '<div class="ann-img" style="top: 1vh;"><img src="./img/default.png" class="anony-image"></div>' +
                        '</div>';
                        $(".darkweb-home-tab").append(AnonElement);
                } else {
                    let AnonElement = '<div class="darkweb-anon" data-annhandler="@Anon-' + Anon.anon+'"><div class="anon-reply"><i class="fas fa-reply"></i></div>'+
                        '<div class="anon-anony">'+'Anon-'+Anon.anon+' &nbsp;<span>'+TimeAgo+'</span></div>'+
                        '<div class="anon-message">'+AnnMessage+'</div>'+
                        '<img class="image" src= ' + Anon.url + ' style = " border-radius:4px; width: 70%; position:relative; z-index: 1; left:52px; margin:.6rem .5rem .6rem 1rem;height: auto; padding-bottom: 15px;">' +
                        '<div class="ann-img" style="top: 1vh;"><img src="./img/default.png" class="anony-image"></div>' +
                        '</div>';
                    $(".darkweb-home-tab").append(AnonElement);
                }
            }else if(Anon.anonym != null) {
                if (Anon.url == "") {
                    let AnonElement = '<div class="darkweb-anon" data-anncid="'+Anon.citizenid+'" data-annid ="'+Anon.anonId+'" data-annhandler="@Anon-' + Anon.anonym+ '"><div class="anon-reply"><i class="fas fa-reply"></i></div>' +
                        '<div class="anon-anony">' + 'Anon-' + Anon.anonym + ' &nbsp;<span>' + TimeAgo + '</span></div>' +
                        '<div class="anon-message">' + AnnMessage + '</div>' +
                        '<div class="ann-img" style="top: 1vh;"><img src="./img/default.png" class="anony-image"></div>' +
                        '</div>';
                        $(".darkweb-home-tab").append(AnonElement);
                } else {
                    let AnonElement = '<div class="darkweb-anon" data-annhandler="@Anon-' + Anon.anon+'"><div class="anon-reply"><i class="fas fa-reply"></i></div>'+
                        '<div class="anon-anony">'+'Anon-'+Anon.anonym+' &nbsp;<span>'+TimeAgo+'</span></div>'+
                        '<div class="anon-message">'+AnnMessage+'</div>'+
                        '<img class="image" src= ' + Anon.url + ' style = " border-radius:4px; width: 70%; position:relative; z-index: 1; left:52px; margin:.6rem .5rem .6rem 1rem;height: auto; padding-bottom: 15px;">' +
                        '<div class="ann-img" style="top: 1vh;"><img src="./img/default.png" class="anony-image"></div>' +
                        '</div>';
                    $(".darkweb-home-tab").append(AnonElement);
                }
            }
        });
    }
}

$(document).on('click','#ann-delete-click',function(e){
    e.preventDefault();
    let source = $('.darkweb-anon').data('annid')
    $(this).parent().parent().parent().parent().remove()
    $.post('https://aj-phone/DeleteAnon', JSON.stringify({id: source}))
})

$(document).on('click', '.anon-reply', function(e){
    e.preventDefault();
    var AnnName = $(this).parent().data('annhandler');

    ClearInputNew()
    $('#ann-box-textt').fadeIn(350);
    $(".ann-box-textt-input").val(AnnName+" ");
});

QB.Phone.Notifications.LoadMentionedAnons = function(Anons) {
    Anons = Anons.reverse();
    $('#anon-new-url').val("");
    if (Anons.length > 0) {
        $(".darkweb-mentions-tab").html("");
        $.each(Anons, function(i, Anon){
            var clean = DOMPurify.sanitize(Anon.message , {
                ALLOWED_TAGS: [],
                ALLOWED_ATTR: []
            });
            if (clean == '') clean = 'Hmm, I shouldn\'t be able to do this...'
            var AnnMessage = QB.Phone.Functions.FormatDarkwebMessage(clean);
            var TimeAgo = moment(Anon.date).format('MM/DD/YYYY hh:mm');

            var DarkwebHandle = Anon.firstName + ' ' + Anon.lastName
            var PictureUrl = "./img/default.png";
            if (Anon.picture !== "default") {
                PictureUrl = Anon.picture
            }

            var AnonElement =
            '<div class="darkweb-anon">'+
                '<div class="anon-anony">'+Anon.firstName+' '+Anon.lastName+' &nbsp;<span>@'+DarkwebHandle.replace(" ", "_")+' &middot; '+TimeAgo+'</span></div>'+
                '<div class="anon-message">'+AnnMessage+'</div>'+
            '<div class="ann-img" style="top: 1vh;"><img src="./img/default.png" class="anony-image"></div></div>';

            $(".darkweb-mentioned-anon").css({"background-color":"#F5F8FA"});
            $(".darkweb-mentions-tab").append(AnonElement);
        });
    }
}

QB.Phone.Functions.FormatDarkwebMessage = function(DarkwebMessage) {
    var AnnMessage = DarkwebMessage;
    var res = AnnMessage.split("@");
    var tags = AnnMessage.split("#");
    var InvalidSymbols = [
        "[",
        "?",
        "!",
        "@",
        "#",
        "]",
    ]

    for(i = 1; i < res.length; i++) {
        var MentionTag = res[i].split(" ")[0];
        if (MentionTag !== null && MentionTag !== undefined && MentionTag !== "") {
            AnnMessage = AnnMessage.replace("@"+MentionTag, "<span class='mentioned-tag3' data-mentiontag='@"+MentionTag+"''>@"+MentionTag+"</span>");
        }
    }

    for(i = 1; i < tags.length; i++) {
        var Hashtag = tags[i].split(" ")[0];

        for(i = 1; i < InvalidSymbols.length; i++){
            var symbol = InvalidSymbols[i];
            var res = Hashtag.indexOf(symbol);

            if (res > -1) {
                Hashtag = Hashtag.replace(symbol, "");
            }
        }

        if (Hashtag !== null && Hashtag !== undefined && Hashtag !== "") {
            AnnMessage = AnnMessage.replace("#"+Hashtag, "<span class='hashtag-tag-text3' data-hashtag='"+Hashtag+"''>#"+Hashtag+"</span>");
        }
    }

    return AnnMessage
}

$(document).on('click', '#send-anon', function(e){
    e.preventDefault();
    var AnonMessage = $("#anon-new-message").val();
    var imageURL = $('#anon-new-url').val()
    if (AnonMessage != "") {
        var CurrentDate = new Date();
        $.post('https://aj-phone/PostNewAnon', JSON.stringify({
            Message: AnonMessage,
            Date: CurrentDate,
            Picture: "default",
            url: imageURL
        }), function(Anons){
            QB.Phone.Notifications.LoadAnons(Anons);
        });
        $.post('https://aj-phone/GetHashtags-dark', JSON.stringify({}), function(Hashtags){
            QB.Phone.Notifications.LoadHashtags_dark(Hashtags)
        })
        QB.Phone.Animations.TopSlideUp(".darkweb-new-anon-tab", 450, -120);
    } else {
        QB.Phone.Notifications.Add("fab fa-darkweb", "Darkweb", "Fill a message!", "#1DA1F2");
    };
    $('#anon-new-url').val("");
    $("#anon-new-message").val("");
});

$(document).on('click', '#cancel-anon', function(e){
    e.preventDefault();
    $('#anon-new-url').html("");
    QB.Phone.Animations.TopSlideUp(".darkweb-new-anon-tab", 450, -120);
});

$(document).on('click', '.image', function(e){
    e.preventDefault();
    let source = $(this).attr('src')
    QB.Screen.popUp(source)
});

$(document).on('click', '.mentioned-tag3', function(e){
    e.preventDefault();
    CopyMentionTag_dark(this);
});

$(document).on('click', '.hashtag-tag-text3', function(e){
    e.preventDefault();
    if (!HashtagOpen) {
        var Hashtag = $(this).data('hashtag');
        var PreviousDarkwebTabObject = $('.darkweb-header').find('[data-darkwebtab="'+CurrentDarkwebTab+'"]');

        $("#darkweb-hashtags").addClass('selected-darkweb-header-tab');
        $(PreviousDarkwebTabObject).removeClass('selected-darkweb-header-tab');

        $("."+CurrentDarkwebTab+"-tab").css({"display":"none"});
        $(".darkweb-hashtags-tab").css({"display":"block"});

        $.post('https://aj-phone/GetHashtagMessages-dark', JSON.stringify({hashtag: Hashtag}), function(HashtagData){
            QB.Phone.Notifications.LoadHashtagMessages_dark(HashtagData.messages);
        });

        $(".darkweb-hashtag-anons").css({"display":"block", "left":"30vh"});
        $(".darkweb-hashtag-anons").css({"left": "0vh"});
        $(".darkweb-hashtags").css({"left": "-30vh"});
        $(".darkweb-hashtags").css({"display":"none"});
        HashtagOpen = true;

        CurrentDarkwebTab = "darkweb-hashtags";
    }
});

function CopyMentionTag_dark(elem) {
    var $temp = $("<input>");
    $("body").append($temp);
    $temp.val($(elem).data('mentiontag')).select();
    QB.Phone.Notifications.Add("fab fa-darkweb", "Darkweb", $(elem).data('mentiontag')+ " copied!", "rgb(27, 149, 224)", 1250);
    document.execCommand("copy");
    $temp.remove();
}

QB.Phone.Notifications.LoadHashtags_dark = function(hashtags) {
    if (hashtags !== null) {
        $(".darkweb-hashtags").html("");

        $.each(hashtags, function(i, hashtag){
            var Elem = '';
            var AnonHandle = "Anon";
            if (hashtag.messages.length > 1 ) {
               AnonHandle = "Anons";
            }
            if (hashtag.messages.length >= MinimumTrending) {
                Elem = '<div class="darkweb-hashtag" id="tag-'+hashtag.hashtag+'"><div class="darkweb-hashtag-status">Trending in City</div> <div class="darkweb-hashtag-tag">#'+hashtag.hashtag+'</div> <div class="darkweb-hashtag-messages">'+hashtag.messages.length+' '+AnonHandle+'</div> </div>';
            } else {
                Elem = '<div class="darkweb-hashtag" id="tag-'+hashtag.hashtag+'"><div class="darkweb-hashtag-status">Not trending in City</div> <div class="darkweb-hashtag-tag">#'+hashtag.hashtag+'</div> <div class="darkweb-hashtag-messages">'+hashtag.messages.length+' '+AnonHandle+'</div> </div>';
            }

            $(".darkweb-hashtags").append(Elem);
            $("#tag-"+hashtag.hashtag).data('tagData', hashtag);
        });
    }
}

QB.Phone.Notifications.LoadHashtagMessages_dark = function(Anons) {
    Anons = Anons.reverse();
    if (Anons !== null && Anons !== undefined && Anons !== "" && Anons.length > 0) {
        $(".darkweb-hashtag-anons").html("");
        $.each(Anons, function(i, Anon){
            var clean = DOMPurify.sanitize(Anon.message , {
                ALLOWED_TAGS: [],
                ALLOWED_ATTR: []
            });
            if (clean == '') clean = 'Hmm, I shouldn\'t be able to do this...'
            var AnnMessage = QB.Phone.Functions.FormatDarkwebMessage(clean);
            var TimeAgo = moment(Anon.date).format('MM/DD/YYYY hh:mm');

            var DarkwebHandle = Anon.firstName + ' ' + Anon.lastName
            var PictureUrl = "./img/default.png"
            if (Anon.picture !== "default") {
                PictureUrl = Anon.picture
            }

            var AnonElement =
            '<div class="darkweb-anon">'+
                '<div class="anon-anony">'+Anon.firstName+' '+Anon.lastName+' &nbsp;<span>@'+DarkwebHandle.replace(" ", "_")+' &middot; '+TimeAgo+'</span></div>'+
                '<div class="anon-message">'+AnnMessage+'</div>'+
            '<div class="ann-img" style="top: 1vh;"><img src="./img/default.png" class="anony-image"></div></div>';

            $(".darkweb-hashtag-anons").append(AnonElement);
        });
    }
}


$(document).on('click', '.darkweb-hashtag', function(event){
    event.preventDefault();

    var AnonId = $(this).attr('id');
    var AnonData = $("#"+AnonId).data('tagData');

    QB.Phone.Notifications.LoadHashtagMessages_dark(AnonData.messages);

    $(".darkweb-hashtag-anons").css({"display":"block", "left":"30vh"});
    $(".darkweb-hashtag-anons").animate({
        left: 0+"vh"
    }, 150);
    $(".darkweb-hashtags").animate({
        left: -30+"vh"
    }, 150, function(){
        $(".darkweb-hashtags").css({"display":"none"});
    });
    HashtagOpen = true;
});
