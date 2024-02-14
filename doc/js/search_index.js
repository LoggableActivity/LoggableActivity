var search_data = {"index":{"searchIndex":["loggableactivity","activity","configuration","encryption","encryptionerror","encryptionkey","hooks","payload","payloadsbuilder","updatepayloadsbuilder","activities_for_actor()","actor_display_name()","attrs()","attrs()","blank?()","build_payloads()","build_update_payloads()","create_encryption_key()","decrypt()","encrypt()","for_class()","for_record()","for_record_by_type_and_id()","latest()","load_config_file()","log()","mark_as_deleted()","primary_payload_attrs()","random_key()","record_display_name()","relations_attrs()","update_activity_attrs()"],"longSearchIndex":["loggableactivity","loggableactivity::activity","loggableactivity::configuration","loggableactivity::encryption","loggableactivity::encryptionerror","loggableactivity::encryptionkey","loggableactivity::hooks","loggableactivity::payload","loggableactivity::payloadsbuilder","loggableactivity::updatepayloadsbuilder","loggableactivity::activity::activities_for_actor()","loggableactivity::activity#actor_display_name()","loggableactivity::activity#attrs()","loggableactivity::payload#attrs()","loggableactivity::encryption::blank?()","loggableactivity::payloadsbuilder#build_payloads()","loggableactivity::updatepayloadsbuilder#build_update_payloads()","loggableactivity::encryptionkey::create_encryption_key()","loggableactivity::encryption::decrypt()","loggableactivity::encryption::encrypt()","loggableactivity::configuration::for_class()","loggableactivity::encryptionkey::for_record()","loggableactivity::encryptionkey::for_record_by_type_and_id()","loggableactivity::activity::latest()","loggableactivity::configuration::load_config_file()","loggableactivity::hooks#log()","loggableactivity::encryptionkey#mark_as_deleted()","loggableactivity::activity#primary_payload_attrs()","loggableactivity::encryptionkey::random_key()","loggableactivity::activity#record_display_name()","loggableactivity::activity#relations_attrs()","loggableactivity::activity#update_activity_attrs()"],"info":[["LoggableActivity","","LoggableActivity.html","",""],["LoggableActivity::Activity","","LoggableActivity/Activity.html","","<p>Represents one action in the activity log.\n"],["LoggableActivity::Configuration","","LoggableActivity/Configuration.html","","<p>This class is used to load the configuration file located at config/loggable_activity.yml\n"],["LoggableActivity::Encryption","","LoggableActivity/Encryption.html","","<p>This module is used to encrypt and decrypt attributes\n"],["LoggableActivity::EncryptionError","","LoggableActivity/EncryptionError.html","","<p>This error is raised when encryption or decryption fails\n"],["LoggableActivity::EncryptionKey","","LoggableActivity/EncryptionKey.html","","<p>This class represents the encryption key used to unlock the data for one payload. When deleted, only …\n"],["LoggableActivity::Hooks","","LoggableActivity/Hooks.html","","<p>This module provides hooks for creating activities when included in a model.\n"],["LoggableActivity::Payload","","LoggableActivity/Payload.html","","<p>This class represents a payload in the log, containing encrypted data of one record in the database. …\n"],["LoggableActivity::PayloadsBuilder","","LoggableActivity/PayloadsBuilder.html","","<p>This module is responsible for building payloads used in loggable activities.\n"],["LoggableActivity::UpdatePayloadsBuilder","","LoggableActivity/UpdatePayloadsBuilder.html","","<p>This module is responsible for building update payloads used in loggable activities.\n"],["activities_for_actor","LoggableActivity::Activity","LoggableActivity/Activity.html#method-c-activities_for_actor","(actor, limit = 20, params = { offset: 0 })","<p>Returns a list of activities for a given actor.\n"],["actor_display_name","LoggableActivity::Activity","LoggableActivity/Activity.html#method-i-actor_display_name","()","<p>Returns the display name for a actor. what method to use if defined in ‘/config/loggable_activity.yaml’ …\n"],["attrs","LoggableActivity::Activity","LoggableActivity/Activity.html#method-i-attrs","()","<p>Returns a list of attributes of the activity includig the indliced relations. The included relations …\n"],["attrs","LoggableActivity::Payload","LoggableActivity/Payload.html#method-i-attrs","()","<p>Returns the decrypted attributes of the payload based on its type.\n<p>@return [Hash] The decrypted attributes. …\n"],["blank?","LoggableActivity::Encryption","LoggableActivity/Encryption.html#method-c-blank-3F","(value)",""],["build_payloads","LoggableActivity::PayloadsBuilder","LoggableActivity/PayloadsBuilder.html#method-i-build_payloads","()","<p>Builds payloads for the loggable activity.\n\n<pre>Example:\n  build_payloads\n\nReturns:\n #&lt;LoggableActivity::Payload:0x0000000109658718&gt; ...</pre>\n"],["build_update_payloads","LoggableActivity::UpdatePayloadsBuilder","LoggableActivity/UpdatePayloadsBuilder.html#method-i-build_update_payloads","()","<p>Builds payloads for an activity update event.\n\n<pre>Example:\n  build_update_payloads\n\n Returns:\n [\n   [0] #&lt;LoggableActivity::Payload:0x00000001047d31d8&gt; ...</pre>\n"],["create_encryption_key","LoggableActivity::EncryptionKey","LoggableActivity/EncryptionKey.html#method-c-create_encryption_key","(record_type, record_id, parent_key = nil)","<p>Creates an encryption key for a record, optionally using a parent key.\n\n<pre>@param record_type [String] The ...</pre>\n"],["decrypt","LoggableActivity::Encryption","LoggableActivity/Encryption.html#method-c-decrypt","(data, encryption_key)","<p>Decrypts the given data using the given encryption key\n<p>Example:\n\n<pre>LoggableActivity::Encryption.decrypt(&#39;SOME_ENCRYPTED_STRING&#39;, ...</pre>\n"],["encrypt","LoggableActivity::Encryption","LoggableActivity/Encryption.html#method-c-encrypt","(data, encryption_key)","<p>Encrypts the given data using the given encryption key\n<p>Example:\n\n<pre>LoggableActivity::Encryption.encrypt(&#39;my ...</pre>\n"],["for_class","LoggableActivity::Configuration","LoggableActivity/Configuration.html#method-c-for_class","(class_name)","<p>Returns the configuration data for the given class\n<p>Example:\n\n<pre class=\"ruby\"><span class=\"ruby-constant\">LoggableActivity</span><span class=\"ruby-operator\">::</span><span class=\"ruby-constant\">Configuration</span>.<span class=\"ruby-identifier\">for_class</span>(<span class=\"ruby-string\">&#39;User&#39;</span>)\n</pre>\n"],["for_record","LoggableActivity::EncryptionKey","LoggableActivity/EncryptionKey.html#method-c-for_record","(record, parent_key = nil)","<p>Returns an encryption key for a record, optionally using a parent key.\n\n<pre>@param record [ActiveRecord::Base] ...</pre>\n"],["for_record_by_type_and_id","LoggableActivity::EncryptionKey","LoggableActivity/EncryptionKey.html#method-c-for_record_by_type_and_id","(record_type, record_id, parent_key = nil)","<p>Returns an encryption key for a record by its type and ID, optionally using a parent key.\n\n<pre>@param record_type ...</pre>\n"],["latest","LoggableActivity::Activity","LoggableActivity/Activity.html#method-c-latest","(limit = 20, params = { offset: 0 })","<p>Returns a list of activities ordered by creation date.\n"],["load_config_file","LoggableActivity::Configuration","LoggableActivity/Configuration.html#method-c-load_config_file","(config_file_path)",""],["log","LoggableActivity::Hooks","LoggableActivity/Hooks.html#method-i-log","(action, actor: nil, params: {})","<p>Logs an activity with the specified action, actor, and params.\n\n<pre>@param action [Symbol] The action to log ...</pre>\n"],["mark_as_deleted","LoggableActivity::EncryptionKey","LoggableActivity/EncryptionKey.html#method-i-mark_as_deleted","()","<p>Marks the encryption key as deleted by updating the key to nil.\n"],["primary_payload_attrs","LoggableActivity::Activity","LoggableActivity/Activity.html#method-i-primary_payload_attrs","()","<p>Returns the attributes for the primary payload, without the relations.\n<p>Example:\n\n<pre class=\"ruby\"><span class=\"ruby-ivar\">@activity</span>.<span class=\"ruby-identifier\">primary_payload_attrs</span>\n</pre>\n"],["random_key","LoggableActivity::EncryptionKey","LoggableActivity/EncryptionKey.html#method-c-random_key","()","<p>Generates a random encryption key.\n\n<pre>@return [String] The generated encryption key.</pre>\n<p>Example:\n"],["record_display_name","LoggableActivity::Activity","LoggableActivity/Activity.html#method-i-record_display_name","()","<p>Returns the display name for a record. what method to use if defined in ‘/config/loggable_activity.yaml’ …\n"],["relations_attrs","LoggableActivity::Activity","LoggableActivity/Activity.html#method-i-relations_attrs","()","<p>Returns the attributes for the relations.\n<p>Example:\n\n<pre class=\"ruby\"><span class=\"ruby-ivar\">@activity</span>.<span class=\"ruby-identifier\">relations_attrs</span>\n</pre>\n"],["update_activity_attrs","LoggableActivity::Activity","LoggableActivity/Activity.html#method-i-update_activity_attrs","()","<p>Returns the attributes of an upddate activity.\n<p>Example:\n\n<pre class=\"ruby\"><span class=\"ruby-ivar\">@activity</span>.<span class=\"ruby-identifier\">update_activity_attrs</span>\n</pre>\n"]]}}