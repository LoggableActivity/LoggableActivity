# Example of a payload attributes
```
{
  'actor_type' => 'User'
  'actor_id' => "12"
  'action' => 'user.update'
  'payloads' => 
    [
        {
          :related_to_activity_as => 'primary',
          :record_type => 'User',
          :record_id => 7,
          :route => 'show_user',
          'attrs' => {
            :first_name => 
              'changed' => 
                {
                  'from' => 'Vo5qr2ZXdnUNvZlFPzPivVnZ4JJMHvftPKR9F5ZidDQ=\n',
                  'to' => 'c4849GlicNeNw/7arZBRu6BCAYNlc7bjfHfpPv4Ra1I=\n'
                }
            last_name => 'Vo9apehbkapd=\n',
            'age' => {
              'from' => 'Whybq9OToAIYjYlP2gbXaieKDXH5Ut/uXc+M9R1OAk8=\n',
              'to' => 'SUvxCLFBl3HUxqYihoj7VU3Ai/GK/ji5APJZNwbERqQ=\n'
            }
          }
        },
        {
          :related_to_activity_as => 'has_one' 
          :record_type => 'Demo::UserProfile',
          :record_id => 7,
          :route => 'show_user'
          :attrs => {,
            :sex =>
             'changed' => 
                {
                  'from' => 'aNY4G6dyaYyg7xiPwGMnGORsMvt8rzOKl7S+sEq1jYY=\n',
                  'to' => 'Pqo5vaojL1SV0DMLL5WQsuNjxcZY+Av/ckCbT00ZKUk=\n'
                },
            religion => 'christianity'
          }
        },
        {
          :related_to_activity_as => 'belongs_to,
          :changed => 
          :payload_attrs => {
            :from => {
              :state => 'current_association'
              :record_type => 'Demo::Address',
              :record_id => 7,
              :route => 'show_address'


            }
            :to => {

            }

          }
        }
    ]
}
```