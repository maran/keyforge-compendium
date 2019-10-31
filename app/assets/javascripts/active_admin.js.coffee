#= require active_admin/base
#= require select2
ready = ->
  $("#tag_card_ids").select2({ width: '300px' });
  $("#card_tag_ids").select2({ width: '300px' });
  $("#card_tag_ids").select2({ width: '300px' });
  $("#faq_source_id").select2({ width: '300px' });
  $("#faq_source_id").select2({ width: '300px' });
  $("#faq_rule_source_id").select2({ width: '300px' });
  $("#faq_card_id").select2({ width: '300px' });
  $("#faq_rule_id").select2({ width: '300px' });

$(document).ready(ready)


