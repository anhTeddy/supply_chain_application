# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file. JavaScript code in this file should be added after the last require_* statement.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require tether
#= require bootstrap
#= require turbolinks
#= require jquery.dataTables
#= require dataTables.bootstrap4
#= require moment
#= require daterangepicker
#= require light-admin
#= require_tree ./channels


$(document).on('ready page:load', () ->
    $('#confirm-delete').on 'show.bs.modal', (e) ->
        $(this).find('#form-delete').attr 'action', $(e.relatedTarget).data('href')
        return
    $('#offer-detail').on 'show.bs.modal', (e) ->
        $(this).find('#form-offer-detail').attr 'action', $(e.relatedTarget).data('href')  
        $(this).find('#request-id-for-offer').val $(e.relatedTarget).data('request')
        return
    $('#confirm-offer').on 'show.bs.modal', (e) ->
        $(this).find('#form-confirm-offer').attr 'action', $(e.relatedTarget).data('href') 
        $(this).find('#offer-accept-id').val $(e.relatedTarget).data('offer') 
        return
    $('#issue-certificate').on 'show.bs.modal', (e) ->
        $(this).find('#form-issue-certificate').attr 'action', $(e.relatedTarget).data('href') 
        $(this).find('#form-grower-id').val $(e.relatedTarget).data('grower') 
        return   
    $('#cancel-certificate').on 'show.bs.modal', (e) ->
        $(this).find('#form-cancel-certificate').attr 'action', $(e.relatedTarget).data('href') 
        $(this).find('#form-certificate-id').val $(e.relatedTarget).data('certificate') 
        return               
)        