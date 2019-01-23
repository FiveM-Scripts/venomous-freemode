var playername;
var totalAmount;
var depositHelper;
var whitdrawHelper;

var BalanceTitle;
var DepositMenu;
var serviceHelper;

var WhitdrawMenu;
var transMenu;
var exitButton;
var menuButton;

$(function(){
  // Load the application
  window.addEventListener('message', function(event) {
    if(event.data.type == "open") {
      var AmountHelper = event.data.AmountHelper;
      var MoneyValue = event.data.totalMoney;
      var totalAmount = '$ ' + MoneyValue.toFixed(2).replace(/(\d)(?=(\d\d\d)+(?!\d))/g, "$1,");

      var playername = event.data.playerName;
      var depositHelper = event.data.DepositHelp;
      var whitdrawHelper = event.data.WhitDrawtHelper;

      var serviceHelper = event.data.serviceHelper;
      var BalanceTitle = event.data.BalanceTitle;
      var menuButton = event.data.menuButton;

      var DepositMenu = event.data.DepositMenu;
      var WhitdrawMenu = event.data.WhitdrawMenu;
      var transMenu = event.data.transMenu;
      var customHelper = event.data.customHelper;
      var ConfirmMenu = event.data.confirmMsg;
      var exitButton = event.data.exitButton;

      $(".player-name").text(event.data.playerName);
      $('.total-amount').text(totalAmount);
      $('.amount-placeholder').text(AmountHelper);

      $(".account-balance").text(BalanceTitle);
      $(".deposit-button").text(DepositMenu);
      $(".service-title").text(serviceHelper);

      $(".whitdraw-button").text(WhitdrawMenu);
      $(".transactions-button").text(transMenu);
      $(".custom-button").text(customHelper);
      
      $(".exit-button").text(exitButton);
      $(".menu-button").text(menuButton);

      $(".deposit-helper").text(depositHelper);
      $(".whitdraw-helper").text(whitdrawHelper);
      
      $("#bank-app").css('display', "block");
      $('#mainMenu').show();
      $('#deposit').hide();
      $('#whitdraw').hide();
      $('#transactions').hide();
    } else if(event.data.type == "close") {
        $("#bank-app").css('display', 'none')
        $.post('http://vf_bank/close', JSON.stringify({}));
      }
  });

  $(document).keydown(function(e) {
    if(e.keyCode == 27 || e.keyCode == 46) {
      $("#bank-app").css('display', 'none')
      $.post('http://vf_bank/close', JSON.stringify({}));
    }

    if(e.keyCode == 13) {
      return false;
    }
  });

  $('[data-toggle="showMenu"]').click(function(){
    $.post('http://vf_bank/navigate', JSON.stringify({}));

    $(".player-name").text(playername);  
    $('#mainMenu').show();
    $('#deposit').hide();
    $('#whitdraw').hide();
    $('#transactions').hide();
  });

  $("#showDeposit").click(function(){
    $.post('http://vf_bank/navigate', JSON.stringify({}));

    $(".deposit-helper").text(depositHelper);
    $(".player-name").text(playername);

    $('#mainMenu').hide();
    $('#deposit').show();
    $('#whitdraw').hide();
    $('#transactions').hide();
  });

  $("#showWhitdraw").click(function(){
    $.post('http://vf_bank/navigate', JSON.stringify({}));
    
    $(".whitdraw-helper").text(whitdrawHelper);
    $(".player-name").text(playername);
    
    $('#mainMenu').hide();
    $('#deposit').hide();
    $('#whitdraw').show();
    $('#transactions').hide();
  }); 

  $("#showTransactions").click(function(){
        $.post('http://vf_bank/navigate', JSON.stringify({}));

        $('#mainMenu').hide();
        $('#deposit').hide();
        $('#whitdraw').hide();
        $('#transactions').show();
  });

  $("#exit").click(function(){
    $.post('http://vf_bank/close');    
    $("#bank-app").css('display', 'none')
  });

  var theButtons = $(".depositButton");
  $(theButtons).click(function() {
    $.post('http://vf_bank/navigate', JSON.stringify({}));
    var amount = $(this).val();
    $.post('http://vf_bank/deposit', JSON.stringify({param: amount }));
  });

  $('#deposit-custom').click(() => {
    var DepositAmount = $('#deposit-amount').val();
    $.post('http://vf_bank/deposit', JSON.stringify({param: DepositAmount }));
    $('#CustomDeposit').modal('hide');
  });

  var theButtons = $(".whitdrawButton");
  $(theButtons).click(function() {
    $.post('http://vf_bank/navigate', JSON.stringify({}));
    var amount = $(this).val();
    $.post('http://vf_bank/whitdraw', JSON.stringify({param: amount }));
  });

  $('#whitdraw-custom').click(() => {
    var amount = $('#whitdraw-amount').val();
    $.post('http://vf_bank/whitdraw', JSON.stringify({param: amount }));
    $('#CustomWhitdraw').modal('hide');
  });

  // Close the application
  $("#close").click(() => {
    $("#bank-app").css('display', 'none')
    $.post('http://vf_bank/close', JSON.stringify({}));
  });
});