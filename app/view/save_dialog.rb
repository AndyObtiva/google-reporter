def save_dialog
  dialog = file_dialog(:save)
  dialog.set_filter_names(['Arquivos CSV', 'Todos Arquivos'])
  dialog.set_filter_extensions(%w[*.csv *.*])
  dialog.set_file_name = 'busca.csv'
  @state.save_path     = dialog.open
end
