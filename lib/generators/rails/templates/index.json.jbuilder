json.<%= plural_table_name %> do
  json.array! @<%= plural_table_name %>, partial: "api/v1/<%= plural_table_name %>/<%= singular_table_name %>", as: :<%= singular_table_name %>
end
