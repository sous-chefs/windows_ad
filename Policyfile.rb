# frozen_string_literal: true

name 'windows_ad'
default_source :supermarket
run_list 'test::default'
cookbook 'windows_ad', path: '.'
cookbook 'test', path: 'test/cookbooks/test'
named_run_list :default, 'test::default'
named_run_list :forest, 'test::setup_forest'
named_run_list :demotion, 'test::demotion'
named_run_list :objects, 'test::setup_forest', 'test::ou', 'test::group', 'test::user'
