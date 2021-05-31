--
-- PostgreSQL database dump
--

-- Dumped from database version 10.15
-- Dumped by pg_dump version 10.15


--
-- Name: admin_event_entity; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.admin_event_entity (
    id character varying(36) NOT NULL,
    admin_event_time bigint,
    realm_id character varying(255),
    operation_type character varying(255),
    auth_realm_id character varying(255),
    auth_client_id character varying(255),
    auth_user_id character varying(255),
    ip_address character varying(255),
    resource_path character varying(2550),
    representation text,
    error character varying(255),
    resource_type character varying(64)
);


ALTER TABLE public.admin_event_entity OWNER TO dba;

--
-- Name: associated_policy; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.associated_policy (
    policy_id character varying(36) NOT NULL,
    associated_policy_id character varying(36) NOT NULL
);


ALTER TABLE public.associated_policy OWNER TO dba;

--
-- Name: authentication_execution; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.authentication_execution (
    id character varying(36) NOT NULL,
    alias character varying(255),
    authenticator character varying(36),
    realm_id character varying(36),
    flow_id character varying(36),
    requirement integer,
    priority integer,
    authenticator_flow boolean DEFAULT false NOT NULL,
    auth_flow_id character varying(36),
    auth_config character varying(36)
);


ALTER TABLE public.authentication_execution OWNER TO dba;

--
-- Name: authentication_flow; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.authentication_flow (
    id character varying(36) NOT NULL,
    alias character varying(255),
    description character varying(255),
    realm_id character varying(36),
    provider_id character varying(36) DEFAULT 'basic-flow'::character varying NOT NULL,
    top_level boolean DEFAULT false NOT NULL,
    built_in boolean DEFAULT false NOT NULL
);


ALTER TABLE public.authentication_flow OWNER TO dba;

--
-- Name: authenticator_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.authenticator_config (
    id character varying(36) NOT NULL,
    alias character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.authenticator_config OWNER TO dba;

--
-- Name: authenticator_config_entry; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.authenticator_config_entry (
    authenticator_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.authenticator_config_entry OWNER TO dba;

--
-- Name: broker_link; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.broker_link (
    identity_provider character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL,
    broker_user_id character varying(255),
    broker_username character varying(255),
    token text,
    user_id character varying(255) NOT NULL
);


ALTER TABLE public.broker_link OWNER TO dba;

--
-- Name: client; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client (
    id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    full_scope_allowed boolean DEFAULT false NOT NULL,
    client_id character varying(255),
    not_before integer,
    public_client boolean DEFAULT false NOT NULL,
    secret character varying(255),
    base_url character varying(255),
    bearer_only boolean DEFAULT false NOT NULL,
    management_url character varying(255),
    surrogate_auth_required boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    protocol character varying(255),
    node_rereg_timeout integer DEFAULT 0,
    frontchannel_logout boolean DEFAULT false NOT NULL,
    consent_required boolean DEFAULT false NOT NULL,
    name character varying(255),
    service_accounts_enabled boolean DEFAULT false NOT NULL,
    client_authenticator_type character varying(255),
    root_url character varying(255),
    description character varying(255),
    registration_token character varying(255),
    standard_flow_enabled boolean DEFAULT true NOT NULL,
    implicit_flow_enabled boolean DEFAULT false NOT NULL,
    direct_access_grants_enabled boolean DEFAULT false NOT NULL,
    always_display_in_console boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client OWNER TO dba;

--
-- Name: client_attributes; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_attributes (
    client_id character varying(36) NOT NULL,
    value character varying(4000),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_attributes OWNER TO dba;

--
-- Name: client_auth_flow_bindings; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_auth_flow_bindings (
    client_id character varying(36) NOT NULL,
    flow_id character varying(36),
    binding_name character varying(255) NOT NULL
);


ALTER TABLE public.client_auth_flow_bindings OWNER TO dba;

--
-- Name: client_initial_access; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_initial_access (
    id character varying(36) NOT NULL,
    realm_id character varying(36) NOT NULL,
    "timestamp" integer,
    expiration integer,
    count integer,
    remaining_count integer
);


ALTER TABLE public.client_initial_access OWNER TO dba;

--
-- Name: client_node_registrations; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_node_registrations (
    client_id character varying(36) NOT NULL,
    value integer,
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_node_registrations OWNER TO dba;

--
-- Name: client_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_scope (
    id character varying(36) NOT NULL,
    name character varying(255),
    realm_id character varying(36),
    description character varying(255),
    protocol character varying(255)
);


ALTER TABLE public.client_scope OWNER TO dba;

--
-- Name: client_scope_attributes; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_scope_attributes (
    scope_id character varying(36) NOT NULL,
    value character varying(2048),
    name character varying(255) NOT NULL
);


ALTER TABLE public.client_scope_attributes OWNER TO dba;

--
-- Name: client_scope_client; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_scope_client (
    client_id character varying(255) NOT NULL,
    scope_id character varying(255) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.client_scope_client OWNER TO dba;

--
-- Name: client_scope_role_mapping; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_scope_role_mapping (
    scope_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.client_scope_role_mapping OWNER TO dba;

--
-- Name: client_session; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_session (
    id character varying(36) NOT NULL,
    client_id character varying(36),
    redirect_uri character varying(255),
    state character varying(255),
    "timestamp" integer,
    session_id character varying(36),
    auth_method character varying(255),
    realm_id character varying(255),
    auth_user_id character varying(36),
    current_action character varying(36)
);


ALTER TABLE public.client_session OWNER TO dba;

--
-- Name: client_session_auth_status; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_session_auth_status (
    authenticator character varying(36) NOT NULL,
    status integer,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_auth_status OWNER TO dba;

--
-- Name: client_session_note; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_session_note (
    name character varying(255) NOT NULL,
    value character varying(255),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_note OWNER TO dba;

--
-- Name: client_session_prot_mapper; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_session_prot_mapper (
    protocol_mapper_id character varying(36) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_prot_mapper OWNER TO dba;

--
-- Name: client_session_role; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_session_role (
    role_id character varying(255) NOT NULL,
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_session_role OWNER TO dba;

--
-- Name: client_user_session_note; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.client_user_session_note (
    name character varying(255) NOT NULL,
    value character varying(2048),
    client_session character varying(36) NOT NULL
);


ALTER TABLE public.client_user_session_note OWNER TO dba;

--
-- Name: component; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.component (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_id character varying(36),
    provider_id character varying(36),
    provider_type character varying(255),
    realm_id character varying(36),
    sub_type character varying(255)
);


ALTER TABLE public.component OWNER TO dba;

--
-- Name: component_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.component_config (
    id character varying(36) NOT NULL,
    component_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(4000)
);


ALTER TABLE public.component_config OWNER TO dba;

--
-- Name: composite_role; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.composite_role (
    composite character varying(36) NOT NULL,
    child_role character varying(36) NOT NULL
);


ALTER TABLE public.composite_role OWNER TO dba;

--
-- Name: credential; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    user_id character varying(36),
    created_date bigint,
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.credential OWNER TO dba;

--
-- Name: databasechangelog; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.databasechangelog (
    id character varying(255) NOT NULL,
    author character varying(255) NOT NULL,
    filename character varying(255) NOT NULL,
    dateexecuted timestamp without time zone NOT NULL,
    orderexecuted integer NOT NULL,
    exectype character varying(10) NOT NULL,
    md5sum character varying(35),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(20),
    contexts character varying(255),
    labels character varying(255),
    deployment_id character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO dba;

--
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp without time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO dba;

--
-- Name: default_client_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.default_client_scope (
    realm_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL,
    default_scope boolean DEFAULT false NOT NULL
);


ALTER TABLE public.default_client_scope OWNER TO dba;

--
-- Name: event_entity; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.event_entity (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    details_json character varying(2550),
    error character varying(255),
    ip_address character varying(255),
    realm_id character varying(255),
    session_id character varying(255),
    event_time bigint,
    type character varying(255),
    user_id character varying(255)
);


ALTER TABLE public.event_entity OWNER TO dba;

--
-- Name: fed_user_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_attribute (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    value character varying(2024)
);


ALTER TABLE public.fed_user_attribute OWNER TO dba;

--
-- Name: fed_user_consent; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.fed_user_consent OWNER TO dba;

--
-- Name: fed_user_consent_cl_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_consent_cl_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.fed_user_consent_cl_scope OWNER TO dba;

--
-- Name: fed_user_credential; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_credential (
    id character varying(36) NOT NULL,
    salt bytea,
    type character varying(255),
    created_date bigint,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36),
    user_label character varying(255),
    secret_data text,
    credential_data text,
    priority integer
);


ALTER TABLE public.fed_user_credential OWNER TO dba;

--
-- Name: fed_user_group_membership; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_group_membership OWNER TO dba;

--
-- Name: fed_user_required_action; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_required_action (
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_required_action OWNER TO dba;

--
-- Name: fed_user_role_mapping; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.fed_user_role_mapping (
    role_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    storage_provider_id character varying(36)
);


ALTER TABLE public.fed_user_role_mapping OWNER TO dba;

--
-- Name: federated_identity; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.federated_identity (
    identity_provider character varying(255) NOT NULL,
    realm_id character varying(36),
    federated_user_id character varying(255),
    federated_username character varying(255),
    token text,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_identity OWNER TO dba;

--
-- Name: federated_user; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.federated_user (
    id character varying(255) NOT NULL,
    storage_provider_id character varying(255),
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.federated_user OWNER TO dba;

--
-- Name: group_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.group_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_attribute OWNER TO dba;

--
-- Name: group_role_mapping; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.group_role_mapping (
    role_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.group_role_mapping OWNER TO dba;

--
-- Name: identity_provider; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.identity_provider (
    internal_id character varying(36) NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    provider_alias character varying(255),
    provider_id character varying(255),
    store_token boolean DEFAULT false NOT NULL,
    authenticate_by_default boolean DEFAULT false NOT NULL,
    realm_id character varying(36),
    add_token_role boolean DEFAULT true NOT NULL,
    trust_email boolean DEFAULT false NOT NULL,
    first_broker_login_flow_id character varying(36),
    post_broker_login_flow_id character varying(36),
    provider_display_name character varying(255),
    link_only boolean DEFAULT false NOT NULL
);


ALTER TABLE public.identity_provider OWNER TO dba;

--
-- Name: identity_provider_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.identity_provider_config (
    identity_provider_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.identity_provider_config OWNER TO dba;

--
-- Name: identity_provider_mapper; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.identity_provider_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    idp_alias character varying(255) NOT NULL,
    idp_mapper_name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.identity_provider_mapper OWNER TO dba;

--
-- Name: idp_mapper_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.idp_mapper_config (
    idp_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.idp_mapper_config OWNER TO dba;

--
-- Name: keycloak_group; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.keycloak_group (
    id character varying(36) NOT NULL,
    name character varying(255),
    parent_group character varying(36) NOT NULL,
    realm_id character varying(36)
);


ALTER TABLE public.keycloak_group OWNER TO dba;

--
-- Name: keycloak_role; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.keycloak_role (
    id character varying(36) NOT NULL,
    client_realm_constraint character varying(255),
    client_role boolean DEFAULT false NOT NULL,
    description character varying(255),
    name character varying(255),
    realm_id character varying(255),
    client character varying(36),
    realm character varying(36)
);


ALTER TABLE public.keycloak_role OWNER TO dba;

--
-- Name: migration_model; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.migration_model (
    id character varying(36) NOT NULL,
    version character varying(36),
    update_time bigint DEFAULT 0 NOT NULL
);


ALTER TABLE public.migration_model OWNER TO dba;

--
-- Name: offline_client_session; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.offline_client_session (
    user_session_id character varying(36) NOT NULL,
    client_id character varying(255) NOT NULL,
    offline_flag character varying(4) NOT NULL,
    "timestamp" integer,
    data text,
    client_storage_provider character varying(36) DEFAULT 'local'::character varying NOT NULL,
    external_client_id character varying(255) DEFAULT 'local'::character varying NOT NULL
);


ALTER TABLE public.offline_client_session OWNER TO dba;

--
-- Name: offline_user_session; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.offline_user_session (
    user_session_id character varying(36) NOT NULL,
    user_id character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    created_on integer NOT NULL,
    offline_flag character varying(4) NOT NULL,
    data text,
    last_session_refresh integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.offline_user_session OWNER TO dba;

--
-- Name: policy_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.policy_config (
    policy_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value text
);


ALTER TABLE public.policy_config OWNER TO dba;

--
-- Name: protocol_mapper; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.protocol_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    protocol character varying(255) NOT NULL,
    protocol_mapper_name character varying(255) NOT NULL,
    client_id character varying(36),
    client_scope_id character varying(36)
);


ALTER TABLE public.protocol_mapper OWNER TO dba;

--
-- Name: protocol_mapper_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.protocol_mapper_config (
    protocol_mapper_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.protocol_mapper_config OWNER TO dba;

--
-- Name: realm; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm (
    id character varying(36) NOT NULL,
    access_code_lifespan integer,
    user_action_lifespan integer,
    access_token_lifespan integer,
    account_theme character varying(255),
    admin_theme character varying(255),
    email_theme character varying(255),
    enabled boolean DEFAULT false NOT NULL,
    events_enabled boolean DEFAULT false NOT NULL,
    events_expiration bigint,
    login_theme character varying(255),
    name character varying(255),
    not_before integer,
    password_policy character varying(2550),
    registration_allowed boolean DEFAULT false NOT NULL,
    remember_me boolean DEFAULT false NOT NULL,
    reset_password_allowed boolean DEFAULT false NOT NULL,
    social boolean DEFAULT false NOT NULL,
    ssl_required character varying(255),
    sso_idle_timeout integer,
    sso_max_lifespan integer,
    update_profile_on_soc_login boolean DEFAULT false NOT NULL,
    verify_email boolean DEFAULT false NOT NULL,
    master_admin_client character varying(36),
    login_lifespan integer,
    internationalization_enabled boolean DEFAULT false NOT NULL,
    default_locale character varying(255),
    reg_email_as_username boolean DEFAULT false NOT NULL,
    admin_events_enabled boolean DEFAULT false NOT NULL,
    admin_events_details_enabled boolean DEFAULT false NOT NULL,
    edit_username_allowed boolean DEFAULT false NOT NULL,
    otp_policy_counter integer DEFAULT 0,
    otp_policy_window integer DEFAULT 1,
    otp_policy_period integer DEFAULT 30,
    otp_policy_digits integer DEFAULT 6,
    otp_policy_alg character varying(36) DEFAULT 'HmacSHA1'::character varying,
    otp_policy_type character varying(36) DEFAULT 'totp'::character varying,
    browser_flow character varying(36),
    registration_flow character varying(36),
    direct_grant_flow character varying(36),
    reset_credentials_flow character varying(36),
    client_auth_flow character varying(36),
    offline_session_idle_timeout integer DEFAULT 0,
    revoke_refresh_token boolean DEFAULT false NOT NULL,
    access_token_life_implicit integer DEFAULT 0,
    login_with_email_allowed boolean DEFAULT true NOT NULL,
    duplicate_emails_allowed boolean DEFAULT false NOT NULL,
    docker_auth_flow character varying(36),
    refresh_token_max_reuse integer DEFAULT 0,
    allow_user_managed_access boolean DEFAULT false NOT NULL,
    sso_max_lifespan_remember_me integer DEFAULT 0 NOT NULL,
    sso_idle_timeout_remember_me integer DEFAULT 0 NOT NULL,
    default_role character varying(255)
);


ALTER TABLE public.realm OWNER TO dba;

--
-- Name: realm_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_attribute (
    name character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL,
    value text
);


ALTER TABLE public.realm_attribute OWNER TO dba;

--
-- Name: realm_default_groups; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_default_groups (
    realm_id character varying(36) NOT NULL,
    group_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_default_groups OWNER TO dba;

--
-- Name: realm_enabled_event_types; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_enabled_event_types (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_enabled_event_types OWNER TO dba;

--
-- Name: realm_events_listeners; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_events_listeners (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_events_listeners OWNER TO dba;

--
-- Name: realm_localizations; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_localizations (
    realm_id character varying(255) NOT NULL,
    locale character varying(255) NOT NULL,
    texts text NOT NULL
);


ALTER TABLE public.realm_localizations OWNER TO dba;

--
-- Name: realm_required_credential; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_required_credential (
    type character varying(255) NOT NULL,
    form_label character varying(255),
    input boolean DEFAULT false NOT NULL,
    secret boolean DEFAULT false NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.realm_required_credential OWNER TO dba;

--
-- Name: realm_smtp_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_smtp_config (
    realm_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.realm_smtp_config OWNER TO dba;

--
-- Name: realm_supported_locales; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.realm_supported_locales (
    realm_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.realm_supported_locales OWNER TO dba;

--
-- Name: redirect_uris; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.redirect_uris (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.redirect_uris OWNER TO dba;

--
-- Name: required_action_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.required_action_config (
    required_action_id character varying(36) NOT NULL,
    value text,
    name character varying(255) NOT NULL
);


ALTER TABLE public.required_action_config OWNER TO dba;

--
-- Name: required_action_provider; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.required_action_provider (
    id character varying(36) NOT NULL,
    alias character varying(255),
    name character varying(255),
    realm_id character varying(36),
    enabled boolean DEFAULT false NOT NULL,
    default_action boolean DEFAULT false NOT NULL,
    provider_id character varying(255),
    priority integer
);


ALTER TABLE public.required_action_provider OWNER TO dba;

--
-- Name: resource_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_attribute (
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255),
    resource_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_attribute OWNER TO dba;

--
-- Name: resource_policy; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_policy (
    resource_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_policy OWNER TO dba;

--
-- Name: resource_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_scope (
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.resource_scope OWNER TO dba;

--
-- Name: resource_server; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_server (
    id character varying(36) NOT NULL,
    allow_rs_remote_mgmt boolean DEFAULT false NOT NULL,
    policy_enforce_mode character varying(15) NOT NULL,
    decision_strategy smallint DEFAULT 1 NOT NULL
);


ALTER TABLE public.resource_server OWNER TO dba;

--
-- Name: resource_server_perm_ticket; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_server_perm_ticket (
    id character varying(36) NOT NULL,
    owner character varying(255) NOT NULL,
    requester character varying(255) NOT NULL,
    created_timestamp bigint NOT NULL,
    granted_timestamp bigint,
    resource_id character varying(36) NOT NULL,
    scope_id character varying(36),
    resource_server_id character varying(36) NOT NULL,
    policy_id character varying(36)
);


ALTER TABLE public.resource_server_perm_ticket OWNER TO dba;

--
-- Name: resource_server_policy; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_server_policy (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    description character varying(255),
    type character varying(255) NOT NULL,
    decision_strategy character varying(20),
    logic character varying(20),
    resource_server_id character varying(36) NOT NULL,
    owner character varying(255)
);


ALTER TABLE public.resource_server_policy OWNER TO dba;

--
-- Name: resource_server_resource; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_server_resource (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    type character varying(255),
    icon_uri character varying(255),
    owner character varying(255) NOT NULL,
    resource_server_id character varying(36) NOT NULL,
    owner_managed_access boolean DEFAULT false NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_resource OWNER TO dba;

--
-- Name: resource_server_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_server_scope (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    icon_uri character varying(255),
    resource_server_id character varying(36) NOT NULL,
    display_name character varying(255)
);


ALTER TABLE public.resource_server_scope OWNER TO dba;

--
-- Name: resource_uris; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.resource_uris (
    resource_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.resource_uris OWNER TO dba;

--
-- Name: role_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.role_attribute (
    id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(255)
);


ALTER TABLE public.role_attribute OWNER TO dba;

--
-- Name: scope_mapping; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.scope_mapping (
    client_id character varying(36) NOT NULL,
    role_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_mapping OWNER TO dba;

--
-- Name: scope_policy; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.scope_policy (
    scope_id character varying(36) NOT NULL,
    policy_id character varying(36) NOT NULL
);


ALTER TABLE public.scope_policy OWNER TO dba;

--
-- Name: user_attribute; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_attribute (
    name character varying(255) NOT NULL,
    value character varying(255),
    user_id character varying(36) NOT NULL,
    id character varying(36) DEFAULT 'sybase-needs-something-here'::character varying NOT NULL
);


ALTER TABLE public.user_attribute OWNER TO dba;

--
-- Name: user_consent; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_consent (
    id character varying(36) NOT NULL,
    client_id character varying(255),
    user_id character varying(36) NOT NULL,
    created_date bigint,
    last_updated_date bigint,
    client_storage_provider character varying(36),
    external_client_id character varying(255)
);


ALTER TABLE public.user_consent OWNER TO dba;

--
-- Name: user_consent_client_scope; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_consent_client_scope (
    user_consent_id character varying(36) NOT NULL,
    scope_id character varying(36) NOT NULL
);


ALTER TABLE public.user_consent_client_scope OWNER TO dba;

--
-- Name: user_entity; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_entity (
    id character varying(36) NOT NULL,
    email character varying(255),
    email_constraint character varying(255),
    email_verified boolean DEFAULT false NOT NULL,
    enabled boolean DEFAULT false NOT NULL,
    federation_link character varying(255),
    first_name character varying(255),
    last_name character varying(255),
    realm_id character varying(255),
    username character varying(255),
    created_timestamp bigint,
    service_account_client_link character varying(255),
    not_before integer DEFAULT 0 NOT NULL
);


ALTER TABLE public.user_entity OWNER TO dba;

--
-- Name: user_federation_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_federation_config (
    user_federation_provider_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_config OWNER TO dba;

--
-- Name: user_federation_mapper; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_federation_mapper (
    id character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    federation_provider_id character varying(36) NOT NULL,
    federation_mapper_type character varying(255) NOT NULL,
    realm_id character varying(36) NOT NULL
);


ALTER TABLE public.user_federation_mapper OWNER TO dba;

--
-- Name: user_federation_mapper_config; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_federation_mapper_config (
    user_federation_mapper_id character varying(36) NOT NULL,
    value character varying(255),
    name character varying(255) NOT NULL
);


ALTER TABLE public.user_federation_mapper_config OWNER TO dba;

--
-- Name: user_federation_provider; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_federation_provider (
    id character varying(36) NOT NULL,
    changed_sync_period integer,
    display_name character varying(255),
    full_sync_period integer,
    last_sync integer,
    priority integer,
    provider_name character varying(255),
    realm_id character varying(36)
);


ALTER TABLE public.user_federation_provider OWNER TO dba;

--
-- Name: user_group_membership; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_group_membership (
    group_id character varying(36) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_group_membership OWNER TO dba;

--
-- Name: user_required_action; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_required_action (
    user_id character varying(36) NOT NULL,
    required_action character varying(255) DEFAULT ' '::character varying NOT NULL
);


ALTER TABLE public.user_required_action OWNER TO dba;

--
-- Name: user_role_mapping; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_role_mapping (
    role_id character varying(255) NOT NULL,
    user_id character varying(36) NOT NULL
);


ALTER TABLE public.user_role_mapping OWNER TO dba;

--
-- Name: user_session; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_session (
    id character varying(36) NOT NULL,
    auth_method character varying(255),
    ip_address character varying(255),
    last_session_refresh integer,
    login_username character varying(255),
    realm_id character varying(255),
    remember_me boolean DEFAULT false NOT NULL,
    started integer,
    user_id character varying(255),
    user_session_state integer,
    broker_session_id character varying(255),
    broker_user_id character varying(255)
);


ALTER TABLE public.user_session OWNER TO dba;

--
-- Name: user_session_note; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.user_session_note (
    user_session character varying(36) NOT NULL,
    name character varying(255) NOT NULL,
    value character varying(2048)
);


ALTER TABLE public.user_session_note OWNER TO dba;

--
-- Name: username_login_failure; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.username_login_failure (
    realm_id character varying(36) NOT NULL,
    username character varying(255) NOT NULL,
    failed_login_not_before integer,
    last_failure bigint,
    last_ip_failure character varying(255),
    num_failures integer
);


ALTER TABLE public.username_login_failure OWNER TO dba;

--
-- Name: web_origins; Type: TABLE; Schema: public; Owner: dba
--

CREATE TABLE public.web_origins (
    client_id character varying(36) NOT NULL,
    value character varying(255) NOT NULL
);


ALTER TABLE public.web_origins OWNER TO dba;

--
-- Data for Name: admin_event_entity; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.admin_event_entity (id, admin_event_time, realm_id, operation_type, auth_realm_id, auth_client_id, auth_user_id, ip_address, resource_path, representation, error, resource_type) FROM stdin;
\.


--
-- Data for Name: associated_policy; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.associated_policy (policy_id, associated_policy_id) FROM stdin;
\.


--
-- Data for Name: authentication_execution; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.authentication_execution (id, alias, authenticator, realm_id, flow_id, requirement, priority, authenticator_flow, auth_flow_id, auth_config) FROM stdin;
449b5068-08cf-4aae-960c-64841095c9bb	\N	auth-cookie	master	5ff407a3-4bdf-4435-ad60-d6f9b0862bda	2	10	f	\N	\N
082ce8db-3c46-406c-a2ad-c06506bb44cd	\N	auth-spnego	master	5ff407a3-4bdf-4435-ad60-d6f9b0862bda	3	20	f	\N	\N
60e19307-7f1f-4ab8-b7ca-ed855fc2d4d4	\N	identity-provider-redirector	master	5ff407a3-4bdf-4435-ad60-d6f9b0862bda	2	25	f	\N	\N
1f1e08df-3ff9-41b4-a9cd-eff0ae5f8a3f	\N	\N	master	5ff407a3-4bdf-4435-ad60-d6f9b0862bda	2	30	t	ed480746-a472-4eb4-98d8-fea742353b7a	\N
124eb349-ba8e-4adc-ae42-88cfe767729c	\N	auth-username-password-form	master	ed480746-a472-4eb4-98d8-fea742353b7a	0	10	f	\N	\N
3259b261-f758-455c-934e-2cc992c40b06	\N	\N	master	ed480746-a472-4eb4-98d8-fea742353b7a	1	20	t	c757930d-a515-4727-8eb6-1a5937a081a4	\N
34b2226b-4d4d-4de3-abe0-ddd894c589e9	\N	conditional-user-configured	master	c757930d-a515-4727-8eb6-1a5937a081a4	0	10	f	\N	\N
954af430-04a4-453b-8952-1971213b7cb3	\N	auth-otp-form	master	c757930d-a515-4727-8eb6-1a5937a081a4	0	20	f	\N	\N
78671a9e-9c65-40ee-a4ae-67679fcf16e2	\N	direct-grant-validate-username	master	2db09a0a-261a-4fbd-bfea-1370dcc82f7f	0	10	f	\N	\N
a03995e0-36a9-4682-a566-b2585c003c88	\N	direct-grant-validate-password	master	2db09a0a-261a-4fbd-bfea-1370dcc82f7f	0	20	f	\N	\N
ac256377-d372-4752-964f-5458eefc9c4a	\N	\N	master	2db09a0a-261a-4fbd-bfea-1370dcc82f7f	1	30	t	8268f07d-5e1b-4473-8f43-d8c3718153ab	\N
7b452b3e-29c9-4f84-a32a-e0ac641dc099	\N	conditional-user-configured	master	8268f07d-5e1b-4473-8f43-d8c3718153ab	0	10	f	\N	\N
f2e951e7-2e50-4a9b-8669-4d3b345e0aaa	\N	direct-grant-validate-otp	master	8268f07d-5e1b-4473-8f43-d8c3718153ab	0	20	f	\N	\N
2242dc28-b6a7-4535-925a-3b5335e673db	\N	registration-page-form	master	a0a4dab1-3776-48db-b6d0-abe6ee66e961	0	10	t	a9b2039a-7cb5-4f2f-a052-9011195642ba	\N
3157281d-e8db-4201-a6ca-f21ccfd19c67	\N	registration-user-creation	master	a9b2039a-7cb5-4f2f-a052-9011195642ba	0	20	f	\N	\N
3bff7a65-325f-4205-a048-29a40c031ba7	\N	registration-profile-action	master	a9b2039a-7cb5-4f2f-a052-9011195642ba	0	40	f	\N	\N
92b27325-3969-4436-a6eb-64954a94e4f0	\N	registration-password-action	master	a9b2039a-7cb5-4f2f-a052-9011195642ba	0	50	f	\N	\N
110cc71e-172f-47b4-b613-e47eb6d5136a	\N	registration-recaptcha-action	master	a9b2039a-7cb5-4f2f-a052-9011195642ba	3	60	f	\N	\N
42941395-2942-4d77-b3cf-dd8eb0a79cd1	\N	reset-credentials-choose-user	master	7b3d04fe-c23b-4dd8-a020-8b93f58dbc9b	0	10	f	\N	\N
5cdb7a49-e597-4e10-90e8-f6abe56c3bb4	\N	reset-credential-email	master	7b3d04fe-c23b-4dd8-a020-8b93f58dbc9b	0	20	f	\N	\N
79e424da-6ad2-4953-adbe-6e218c85f263	\N	reset-password	master	7b3d04fe-c23b-4dd8-a020-8b93f58dbc9b	0	30	f	\N	\N
679449a0-7a9e-4348-b178-2488358aacee	\N	\N	master	7b3d04fe-c23b-4dd8-a020-8b93f58dbc9b	1	40	t	d18b2f2a-22a1-49d5-9342-f8afd1e0f056	\N
0b3a5a85-4663-4870-9bac-78d119fd3841	\N	conditional-user-configured	master	d18b2f2a-22a1-49d5-9342-f8afd1e0f056	0	10	f	\N	\N
633b9404-654a-46b4-a6bf-f323889b7db9	\N	reset-otp	master	d18b2f2a-22a1-49d5-9342-f8afd1e0f056	0	20	f	\N	\N
b54b64eb-0afb-460a-ab8d-660716f2bc5b	\N	client-secret	master	374bf462-485b-4a3b-9eb2-1c3589356db0	2	10	f	\N	\N
1b3cf303-a337-4eda-846c-45ce1c196700	\N	client-jwt	master	374bf462-485b-4a3b-9eb2-1c3589356db0	2	20	f	\N	\N
8d86b378-35ee-474e-be91-6efcf9502b6a	\N	client-secret-jwt	master	374bf462-485b-4a3b-9eb2-1c3589356db0	2	30	f	\N	\N
4bd75244-dc59-4c3b-b060-ac538ea11ff0	\N	client-x509	master	374bf462-485b-4a3b-9eb2-1c3589356db0	2	40	f	\N	\N
4c2e9b8f-367c-4d58-9cb9-67e94fe1942e	\N	idp-review-profile	master	e1d85a83-d844-43d8-89b0-a3248d0b4bd9	0	10	f	\N	f70ab3ef-c53f-439d-98b1-a7669db75338
731e5935-e2dd-4781-b336-147de854a987	\N	\N	master	e1d85a83-d844-43d8-89b0-a3248d0b4bd9	0	20	t	33021bf0-714b-42f7-a95f-fde228d41280	\N
13c179bf-bd0e-4594-97ec-fac584b98605	\N	idp-create-user-if-unique	master	33021bf0-714b-42f7-a95f-fde228d41280	2	10	f	\N	db4241c9-a06a-4d81-8e86-120ab69d2351
a8714cf0-a85c-47f7-8c8f-b159f5316098	\N	\N	master	33021bf0-714b-42f7-a95f-fde228d41280	2	20	t	fbe0a852-1ab6-4618-9579-2cbd05fe96e8	\N
c3532a83-a577-45ce-9b29-29d74a194eb5	\N	idp-confirm-link	master	fbe0a852-1ab6-4618-9579-2cbd05fe96e8	0	10	f	\N	\N
454335f2-2a1a-4b85-a4d2-584fc87d4fe4	\N	\N	master	fbe0a852-1ab6-4618-9579-2cbd05fe96e8	0	20	t	92228d85-71de-4795-b809-7702ff870b3a	\N
8aa52a50-75c4-4ca5-b2bb-202ebf57a4e0	\N	idp-email-verification	master	92228d85-71de-4795-b809-7702ff870b3a	2	10	f	\N	\N
12fd6c04-6524-4f3c-b392-d40b67d4afa6	\N	\N	master	92228d85-71de-4795-b809-7702ff870b3a	2	20	t	c4bfd029-2b40-48ba-99e2-575e41fd1bfc	\N
b5ee6ead-cbf4-4706-9019-bf2b1478038a	\N	idp-username-password-form	master	c4bfd029-2b40-48ba-99e2-575e41fd1bfc	0	10	f	\N	\N
e47877c7-9040-4c3c-9852-8d4769babb57	\N	\N	master	c4bfd029-2b40-48ba-99e2-575e41fd1bfc	1	20	t	472e371f-d5e4-4e25-9e81-29374c6f066c	\N
3f84fabb-1f0b-495f-8228-14713745335d	\N	conditional-user-configured	master	472e371f-d5e4-4e25-9e81-29374c6f066c	0	10	f	\N	\N
8a6b8fd6-9639-466c-9ab2-a9718bf242e8	\N	auth-otp-form	master	472e371f-d5e4-4e25-9e81-29374c6f066c	0	20	f	\N	\N
d6e7811f-a40d-445d-9c05-25cf1b758b1f	\N	http-basic-authenticator	master	7783656f-fdfa-4c49-8dd3-201425e1314b	0	10	f	\N	\N
ec7fb2d0-1bbf-457e-9839-e32248c9a190	\N	docker-http-basic-authenticator	master	9d13d43a-263d-497d-a91a-eaa08752d402	0	10	f	\N	\N
74f5ddcd-8bb2-4373-bd32-11f36f8dd21a	\N	no-cookie-redirect	master	74592e64-edcc-40a3-ae88-5f2b4628c7de	0	10	f	\N	\N
df0f543a-fa36-442d-a618-31f043ed967e	\N	\N	master	74592e64-edcc-40a3-ae88-5f2b4628c7de	0	20	t	0a568e6b-e6ad-43d7-a778-e4552db82528	\N
dafb59ae-4d11-401e-81a9-ffc32d467dec	\N	basic-auth	master	0a568e6b-e6ad-43d7-a778-e4552db82528	0	10	f	\N	\N
94ce3173-da45-43a9-909c-a642c841e8fa	\N	basic-auth-otp	master	0a568e6b-e6ad-43d7-a778-e4552db82528	3	20	f	\N	\N
a78ee8cc-0edb-49ea-9d25-7ed334a40537	\N	auth-spnego	master	0a568e6b-e6ad-43d7-a778-e4552db82528	3	30	f	\N	\N
\.


--
-- Data for Name: authentication_flow; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.authentication_flow (id, alias, description, realm_id, provider_id, top_level, built_in) FROM stdin;
5ff407a3-4bdf-4435-ad60-d6f9b0862bda	browser	browser based authentication	master	basic-flow	t	t
ed480746-a472-4eb4-98d8-fea742353b7a	forms	Username, password, otp and other auth forms.	master	basic-flow	f	t
c757930d-a515-4727-8eb6-1a5937a081a4	Browser - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
2db09a0a-261a-4fbd-bfea-1370dcc82f7f	direct grant	OpenID Connect Resource Owner Grant	master	basic-flow	t	t
8268f07d-5e1b-4473-8f43-d8c3718153ab	Direct Grant - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
a0a4dab1-3776-48db-b6d0-abe6ee66e961	registration	registration flow	master	basic-flow	t	t
a9b2039a-7cb5-4f2f-a052-9011195642ba	registration form	registration form	master	form-flow	f	t
7b3d04fe-c23b-4dd8-a020-8b93f58dbc9b	reset credentials	Reset credentials for a user if they forgot their password or something	master	basic-flow	t	t
d18b2f2a-22a1-49d5-9342-f8afd1e0f056	Reset - Conditional OTP	Flow to determine if the OTP should be reset or not. Set to REQUIRED to force.	master	basic-flow	f	t
374bf462-485b-4a3b-9eb2-1c3589356db0	clients	Base authentication for clients	master	client-flow	t	t
e1d85a83-d844-43d8-89b0-a3248d0b4bd9	first broker login	Actions taken after first broker login with identity provider account, which is not yet linked to any Keycloak account	master	basic-flow	t	t
33021bf0-714b-42f7-a95f-fde228d41280	User creation or linking	Flow for the existing/non-existing user alternatives	master	basic-flow	f	t
fbe0a852-1ab6-4618-9579-2cbd05fe96e8	Handle Existing Account	Handle what to do if there is existing account with same email/username like authenticated identity provider	master	basic-flow	f	t
92228d85-71de-4795-b809-7702ff870b3a	Account verification options	Method with which to verity the existing account	master	basic-flow	f	t
c4bfd029-2b40-48ba-99e2-575e41fd1bfc	Verify Existing Account by Re-authentication	Reauthentication of existing account	master	basic-flow	f	t
472e371f-d5e4-4e25-9e81-29374c6f066c	First broker login - Conditional OTP	Flow to determine if the OTP is required for the authentication	master	basic-flow	f	t
7783656f-fdfa-4c49-8dd3-201425e1314b	saml ecp	SAML ECP Profile Authentication Flow	master	basic-flow	t	t
9d13d43a-263d-497d-a91a-eaa08752d402	docker auth	Used by Docker clients to authenticate against the IDP	master	basic-flow	t	t
74592e64-edcc-40a3-ae88-5f2b4628c7de	http challenge	An authentication flow based on challenge-response HTTP Authentication Schemes	master	basic-flow	t	t
0a568e6b-e6ad-43d7-a778-e4552db82528	Authentication Options	Authentication options.	master	basic-flow	f	t
\.


--
-- Data for Name: authenticator_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.authenticator_config (id, alias, realm_id) FROM stdin;
f70ab3ef-c53f-439d-98b1-a7669db75338	review profile config	master
db4241c9-a06a-4d81-8e86-120ab69d2351	create unique user config	master
\.


--
-- Data for Name: authenticator_config_entry; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.authenticator_config_entry (authenticator_id, value, name) FROM stdin;
f70ab3ef-c53f-439d-98b1-a7669db75338	missing	update.profile.on.first.login
db4241c9-a06a-4d81-8e86-120ab69d2351	false	require.password.update.after.registration
\.


--
-- Data for Name: broker_link; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.broker_link (identity_provider, storage_provider_id, realm_id, broker_user_id, broker_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: client; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client (id, enabled, full_scope_allowed, client_id, not_before, public_client, secret, base_url, bearer_only, management_url, surrogate_auth_required, realm_id, protocol, node_rereg_timeout, frontchannel_logout, consent_required, name, service_accounts_enabled, client_authenticator_type, root_url, description, registration_token, standard_flow_enabled, implicit_flow_enabled, direct_access_grants_enabled, always_display_in_console) FROM stdin;
ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	f	master-realm	0	f	\N	\N	t	\N	f	master	\N	0	f	f	master Realm	f	client-secret	\N	\N	\N	t	f	f	f
4c399d41-a384-46c8-9304-c6de80835fce	t	f	account	0	t	\N	/realms/master/account/	f	\N	f	master	openid-connect	0	f	f	${client_account}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
04148fd2-01ed-4d18-b014-b6f6fb57c94b	t	f	account-console	0	t	\N	/realms/master/account/	f	\N	f	master	openid-connect	0	f	f	${client_account-console}	f	client-secret	${authBaseUrl}	\N	\N	t	f	f	f
9c3361c5-b2cf-44a6-8af7-ca12a481fe79	t	f	broker	0	f	\N	\N	t	\N	f	master	openid-connect	0	f	f	${client_broker}	f	client-secret	\N	\N	\N	t	f	f	f
2f459e08-5b14-48b6-a51b-6f655329f5b7	t	f	security-admin-console	0	t	\N	/admin/master/console/	f	\N	f	master	openid-connect	0	f	f	${client_security-admin-console}	f	client-secret	${authAdminUrl}	\N	\N	t	f	f	f
d92f4519-26fa-4127-85b5-388556fa3ada	t	f	admin-cli	0	t	\N	\N	f	\N	f	master	openid-connect	0	f	f	${client_admin-cli}	f	client-secret	\N	\N	\N	f	f	t	f
\.


--
-- Data for Name: client_attributes; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_attributes (client_id, value, name) FROM stdin;
04148fd2-01ed-4d18-b014-b6f6fb57c94b	S256	pkce.code.challenge.method
2f459e08-5b14-48b6-a51b-6f655329f5b7	S256	pkce.code.challenge.method
\.


--
-- Data for Name: client_auth_flow_bindings; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_auth_flow_bindings (client_id, flow_id, binding_name) FROM stdin;
\.


--
-- Data for Name: client_initial_access; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_initial_access (id, realm_id, "timestamp", expiration, count, remaining_count) FROM stdin;
\.


--
-- Data for Name: client_node_registrations; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_node_registrations (client_id, value, name) FROM stdin;
\.


--
-- Data for Name: client_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_scope (id, name, realm_id, description, protocol) FROM stdin;
c438bd59-04c6-4baa-92d9-91302d66dafc	offline_access	master	OpenID Connect built-in scope: offline_access	openid-connect
449798f8-bc2f-46c2-b0db-69c71a95191a	role_list	master	SAML role list	saml
22836b16-7858-4f3b-9ebb-25c6575b27c8	profile	master	OpenID Connect built-in scope: profile	openid-connect
f02d0379-b1f6-45f0-a0e7-158d4e80c796	email	master	OpenID Connect built-in scope: email	openid-connect
df40a125-8f46-459a-bf16-52cab4495254	address	master	OpenID Connect built-in scope: address	openid-connect
daa21f96-bb34-4129-a50e-e0f97390a05c	phone	master	OpenID Connect built-in scope: phone	openid-connect
856de14e-e751-4f95-afd5-ad4db6dcbabc	roles	master	OpenID Connect scope for add user roles to the access token	openid-connect
3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7	web-origins	master	OpenID Connect scope for add allowed web origins to the access token	openid-connect
59dd2863-25f0-4b3f-8fd6-dab21e41ba41	microprofile-jwt	master	Microprofile - JWT built-in scope	openid-connect
\.


--
-- Data for Name: client_scope_attributes; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_scope_attributes (scope_id, value, name) FROM stdin;
c438bd59-04c6-4baa-92d9-91302d66dafc	true	display.on.consent.screen
c438bd59-04c6-4baa-92d9-91302d66dafc	${offlineAccessScopeConsentText}	consent.screen.text
449798f8-bc2f-46c2-b0db-69c71a95191a	true	display.on.consent.screen
449798f8-bc2f-46c2-b0db-69c71a95191a	${samlRoleListScopeConsentText}	consent.screen.text
22836b16-7858-4f3b-9ebb-25c6575b27c8	true	display.on.consent.screen
22836b16-7858-4f3b-9ebb-25c6575b27c8	${profileScopeConsentText}	consent.screen.text
22836b16-7858-4f3b-9ebb-25c6575b27c8	true	include.in.token.scope
f02d0379-b1f6-45f0-a0e7-158d4e80c796	true	display.on.consent.screen
f02d0379-b1f6-45f0-a0e7-158d4e80c796	${emailScopeConsentText}	consent.screen.text
f02d0379-b1f6-45f0-a0e7-158d4e80c796	true	include.in.token.scope
df40a125-8f46-459a-bf16-52cab4495254	true	display.on.consent.screen
df40a125-8f46-459a-bf16-52cab4495254	${addressScopeConsentText}	consent.screen.text
df40a125-8f46-459a-bf16-52cab4495254	true	include.in.token.scope
daa21f96-bb34-4129-a50e-e0f97390a05c	true	display.on.consent.screen
daa21f96-bb34-4129-a50e-e0f97390a05c	${phoneScopeConsentText}	consent.screen.text
daa21f96-bb34-4129-a50e-e0f97390a05c	true	include.in.token.scope
856de14e-e751-4f95-afd5-ad4db6dcbabc	true	display.on.consent.screen
856de14e-e751-4f95-afd5-ad4db6dcbabc	${rolesScopeConsentText}	consent.screen.text
856de14e-e751-4f95-afd5-ad4db6dcbabc	false	include.in.token.scope
3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7	false	display.on.consent.screen
3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7		consent.screen.text
3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7	false	include.in.token.scope
59dd2863-25f0-4b3f-8fd6-dab21e41ba41	false	display.on.consent.screen
59dd2863-25f0-4b3f-8fd6-dab21e41ba41	true	include.in.token.scope
\.


--
-- Data for Name: client_scope_client; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_scope_client (client_id, scope_id, default_scope) FROM stdin;
4c399d41-a384-46c8-9304-c6de80835fce	f02d0379-b1f6-45f0-a0e7-158d4e80c796	t
4c399d41-a384-46c8-9304-c6de80835fce	3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7	t
4c399d41-a384-46c8-9304-c6de80835fce	22836b16-7858-4f3b-9ebb-25c6575b27c8	t
4c399d41-a384-46c8-9304-c6de80835fce	856de14e-e751-4f95-afd5-ad4db6dcbabc	t
4c399d41-a384-46c8-9304-c6de80835fce	59dd2863-25f0-4b3f-8fd6-dab21e41ba41	f
4c399d41-a384-46c8-9304-c6de80835fce	df40a125-8f46-459a-bf16-52cab4495254	f
4c399d41-a384-46c8-9304-c6de80835fce	c438bd59-04c6-4baa-92d9-91302d66dafc	f
4c399d41-a384-46c8-9304-c6de80835fce	daa21f96-bb34-4129-a50e-e0f97390a05c	f
04148fd2-01ed-4d18-b014-b6f6fb57c94b	f02d0379-b1f6-45f0-a0e7-158d4e80c796	t
04148fd2-01ed-4d18-b014-b6f6fb57c94b	3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7	t
04148fd2-01ed-4d18-b014-b6f6fb57c94b	22836b16-7858-4f3b-9ebb-25c6575b27c8	t
04148fd2-01ed-4d18-b014-b6f6fb57c94b	856de14e-e751-4f95-afd5-ad4db6dcbabc	t
04148fd2-01ed-4d18-b014-b6f6fb57c94b	59dd2863-25f0-4b3f-8fd6-dab21e41ba41	f
04148fd2-01ed-4d18-b014-b6f6fb57c94b	df40a125-8f46-459a-bf16-52cab4495254	f
04148fd2-01ed-4d18-b014-b6f6fb57c94b	c438bd59-04c6-4baa-92d9-91302d66dafc	f
04148fd2-01ed-4d18-b014-b6f6fb57c94b	daa21f96-bb34-4129-a50e-e0f97390a05c	f
d92f4519-26fa-4127-85b5-388556fa3ada	f02d0379-b1f6-45f0-a0e7-158d4e80c796	t
d92f4519-26fa-4127-85b5-388556fa3ada	3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7	t
d92f4519-26fa-4127-85b5-388556fa3ada	22836b16-7858-4f3b-9ebb-25c6575b27c8	t
d92f4519-26fa-4127-85b5-388556fa3ada	856de14e-e751-4f95-afd5-ad4db6dcbabc	t
d92f4519-26fa-4127-85b5-388556fa3ada	59dd2863-25f0-4b3f-8fd6-dab21e41ba41	f
d92f4519-26fa-4127-85b5-388556fa3ada	df40a125-8f46-459a-bf16-52cab4495254	f
d92f4519-26fa-4127-85b5-388556fa3ada	c438bd59-04c6-4baa-92d9-91302d66dafc	f
d92f4519-26fa-4127-85b5-388556fa3ada	daa21f96-bb34-4129-a50e-e0f97390a05c	f
9c3361c5-b2cf-44a6-8af7-ca12a481fe79	f02d0379-b1f6-45f0-a0e7-158d4e80c796	t
9c3361c5-b2cf-44a6-8af7-ca12a481fe79	3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7	t
9c3361c5-b2cf-44a6-8af7-ca12a481fe79	22836b16-7858-4f3b-9ebb-25c6575b27c8	t
9c3361c5-b2cf-44a6-8af7-ca12a481fe79	856de14e-e751-4f95-afd5-ad4db6dcbabc	t
9c3361c5-b2cf-44a6-8af7-ca12a481fe79	59dd2863-25f0-4b3f-8fd6-dab21e41ba41	f
9c3361c5-b2cf-44a6-8af7-ca12a481fe79	df40a125-8f46-459a-bf16-52cab4495254	f
9c3361c5-b2cf-44a6-8af7-ca12a481fe79	c438bd59-04c6-4baa-92d9-91302d66dafc	f
9c3361c5-b2cf-44a6-8af7-ca12a481fe79	daa21f96-bb34-4129-a50e-e0f97390a05c	f
ce7c7738-b3f6-439c-8371-856bfb8ec2f9	f02d0379-b1f6-45f0-a0e7-158d4e80c796	t
ce7c7738-b3f6-439c-8371-856bfb8ec2f9	3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7	t
ce7c7738-b3f6-439c-8371-856bfb8ec2f9	22836b16-7858-4f3b-9ebb-25c6575b27c8	t
ce7c7738-b3f6-439c-8371-856bfb8ec2f9	856de14e-e751-4f95-afd5-ad4db6dcbabc	t
ce7c7738-b3f6-439c-8371-856bfb8ec2f9	59dd2863-25f0-4b3f-8fd6-dab21e41ba41	f
ce7c7738-b3f6-439c-8371-856bfb8ec2f9	df40a125-8f46-459a-bf16-52cab4495254	f
ce7c7738-b3f6-439c-8371-856bfb8ec2f9	c438bd59-04c6-4baa-92d9-91302d66dafc	f
ce7c7738-b3f6-439c-8371-856bfb8ec2f9	daa21f96-bb34-4129-a50e-e0f97390a05c	f
2f459e08-5b14-48b6-a51b-6f655329f5b7	f02d0379-b1f6-45f0-a0e7-158d4e80c796	t
2f459e08-5b14-48b6-a51b-6f655329f5b7	3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7	t
2f459e08-5b14-48b6-a51b-6f655329f5b7	22836b16-7858-4f3b-9ebb-25c6575b27c8	t
2f459e08-5b14-48b6-a51b-6f655329f5b7	856de14e-e751-4f95-afd5-ad4db6dcbabc	t
2f459e08-5b14-48b6-a51b-6f655329f5b7	59dd2863-25f0-4b3f-8fd6-dab21e41ba41	f
2f459e08-5b14-48b6-a51b-6f655329f5b7	df40a125-8f46-459a-bf16-52cab4495254	f
2f459e08-5b14-48b6-a51b-6f655329f5b7	c438bd59-04c6-4baa-92d9-91302d66dafc	f
2f459e08-5b14-48b6-a51b-6f655329f5b7	daa21f96-bb34-4129-a50e-e0f97390a05c	f
\.


--
-- Data for Name: client_scope_role_mapping; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_scope_role_mapping (scope_id, role_id) FROM stdin;
c438bd59-04c6-4baa-92d9-91302d66dafc	7dfc5846-32ce-4618-a35f-f790987a452b
\.


--
-- Data for Name: client_session; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_session (id, client_id, redirect_uri, state, "timestamp", session_id, auth_method, realm_id, auth_user_id, current_action) FROM stdin;
\.


--
-- Data for Name: client_session_auth_status; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_session_auth_status (authenticator, status, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_note; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_prot_mapper; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_session_prot_mapper (protocol_mapper_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_session_role; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_session_role (role_id, client_session) FROM stdin;
\.


--
-- Data for Name: client_user_session_note; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.client_user_session_note (name, value, client_session) FROM stdin;
\.


--
-- Data for Name: component; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.component (id, name, parent_id, provider_id, provider_type, realm_id, sub_type) FROM stdin;
7cf45f5d-e5ec-4b38-9d93-940a2f2a6206	Trusted Hosts	master	trusted-hosts	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
d1baad70-5efc-4ace-97f3-ae014eb26fa5	Consent Required	master	consent-required	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
c05bb63d-c5b2-4907-a6ce-d2160abe93d7	Full Scope Disabled	master	scope	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
507ddb6b-723f-44bc-97d7-b6e16b5a215d	Max Clients Limit	master	max-clients	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
f40e2dad-2133-4846-95be-7a39ac2dd50a	Allowed Protocol Mapper Types	master	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
b529a337-e7b6-4a19-8377-800640b94798	Allowed Client Scopes	master	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	anonymous
402e28ad-7a14-427a-b640-6fcfb7a85d31	Allowed Protocol Mapper Types	master	allowed-protocol-mappers	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	authenticated
3b778ea9-9a2b-4c65-952d-a4b16a16ab01	Allowed Client Scopes	master	allowed-client-templates	org.keycloak.services.clientregistration.policy.ClientRegistrationPolicy	master	authenticated
402bd4aa-5452-479e-9661-a99bedd6a2f8	rsa-generated	master	rsa-generated	org.keycloak.keys.KeyProvider	master	\N
38b57918-6bc5-4025-b957-b909cf07bfa1	hmac-generated	master	hmac-generated	org.keycloak.keys.KeyProvider	master	\N
cc07f4d9-5067-459a-b727-13e2cf71877b	aes-generated	master	aes-generated	org.keycloak.keys.KeyProvider	master	\N
\.


--
-- Data for Name: component_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.component_config (id, component_id, name, value) FROM stdin;
9744c123-5b0f-4fb2-a8d2-519b25373317	f40e2dad-2133-4846-95be-7a39ac2dd50a	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
f9405a6f-4913-4415-9d92-69764c3715bf	f40e2dad-2133-4846-95be-7a39ac2dd50a	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
336d3b99-5cc6-483c-abb7-848967619729	f40e2dad-2133-4846-95be-7a39ac2dd50a	allowed-protocol-mapper-types	saml-user-attribute-mapper
2e50eaaf-7847-4ae8-b0cc-68466d1acf51	f40e2dad-2133-4846-95be-7a39ac2dd50a	allowed-protocol-mapper-types	oidc-address-mapper
87d01332-9356-45af-a59d-33b005294daf	f40e2dad-2133-4846-95be-7a39ac2dd50a	allowed-protocol-mapper-types	saml-role-list-mapper
f2ebd6e6-a380-4fae-b6a5-a01cdf6840f7	f40e2dad-2133-4846-95be-7a39ac2dd50a	allowed-protocol-mapper-types	saml-user-property-mapper
b2666e32-77c1-461f-a00c-eba02c94962e	f40e2dad-2133-4846-95be-7a39ac2dd50a	allowed-protocol-mapper-types	oidc-full-name-mapper
bb4d3585-bed2-4d00-97de-ba2ee63f2b60	f40e2dad-2133-4846-95be-7a39ac2dd50a	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
20fcd3fa-3bc7-4ee9-bc6f-a6e475e75b9d	3b778ea9-9a2b-4c65-952d-a4b16a16ab01	allow-default-scopes	true
01421262-756b-4407-8e1a-1b89783283fe	7cf45f5d-e5ec-4b38-9d93-940a2f2a6206	host-sending-registration-request-must-match	true
1ba284ce-36bd-4634-b731-a583d46a1835	7cf45f5d-e5ec-4b38-9d93-940a2f2a6206	client-uris-must-match	true
68ce8b29-116a-466d-91a2-8a55a162eb35	b529a337-e7b6-4a19-8377-800640b94798	allow-default-scopes	true
3ead8e84-29c4-4b3f-986a-853c4d0aaee3	507ddb6b-723f-44bc-97d7-b6e16b5a215d	max-clients	200
fa9db162-d01d-4307-b5f3-d60f59d1fd9f	402e28ad-7a14-427a-b640-6fcfb7a85d31	allowed-protocol-mapper-types	oidc-usermodel-attribute-mapper
27d91785-269b-45f5-a750-b7874cd5bfa3	402e28ad-7a14-427a-b640-6fcfb7a85d31	allowed-protocol-mapper-types	oidc-full-name-mapper
3bb02ed8-b28b-4c06-a24c-7a8e26cf85f8	402e28ad-7a14-427a-b640-6fcfb7a85d31	allowed-protocol-mapper-types	saml-role-list-mapper
8974a913-d517-4e23-8d94-f36c5d86788a	402e28ad-7a14-427a-b640-6fcfb7a85d31	allowed-protocol-mapper-types	saml-user-property-mapper
28be4605-606f-4ece-a456-684f133f6591	402e28ad-7a14-427a-b640-6fcfb7a85d31	allowed-protocol-mapper-types	oidc-usermodel-property-mapper
9afdb4d9-8e43-47d6-9880-d7a85c1cb474	402e28ad-7a14-427a-b640-6fcfb7a85d31	allowed-protocol-mapper-types	oidc-sha256-pairwise-sub-mapper
d3795d87-74bb-44a0-a7de-f4074962eb8f	402e28ad-7a14-427a-b640-6fcfb7a85d31	allowed-protocol-mapper-types	saml-user-attribute-mapper
5ec05bae-36b8-40fa-991e-c702699166bf	402e28ad-7a14-427a-b640-6fcfb7a85d31	allowed-protocol-mapper-types	oidc-address-mapper
68b23c04-3910-4ebe-9986-52511d2358d4	402bd4aa-5452-479e-9661-a99bedd6a2f8	certificate	MIICmzCCAYMCBgF5mKgkRTANBgkqhkiG9w0BAQsFADARMQ8wDQYDVQQDDAZtYXN0ZXIwHhcNMjEwNTIzMDk1NTI2WhcNMzEwNTIzMDk1NzA2WjARMQ8wDQYDVQQDDAZtYXN0ZXIwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCr9ozS0Ki1utYNxhcPRePoq4kJThms0hGCxDhAuv4Iz3Biu+KNpgcrTfNmvr4bM1YdRSsvDBQCOEEmo2VUFWZNOxTYN1584tpft8xXzFn2kC+ebTjfRnj+uUJru0c4LAXPaN8rMjUNANJgDxk0U+vrKlCPNj9cE9yqVN7XAAmt6ZGTJUyYxmZOxdpqydWI3f0xLr2o2HM0m7mSwM7DDdk3KHKytS1dQgto/67/GlILeAckFkH32GVSNe9r7JNBqOY3ZJGBIYfR1utQWMv90LSNRTGREvNecXxu2fdHlOgsLimvfOPN8A5p3hdtP8uRDYbwEiblSmP3x05yUsX9TuYrAgMBAAEwDQYJKoZIhvcNAQELBQADggEBAG7mBj5+GZmZr2nXm3nVYp3LIW31U1V9XEJ4moyL4a2jxF98j3EwR9Gp3Zk/8PdLHjxl7grHgu7lqrEdkTW6hEKKa7B9YJh2XRKtcXpGepJ/l0p/jaAVYrchaV8hR+hmYEWN+opr1HfG008ttWYQTGIaE58SmakZ0SKJ5m77RfC55CzYSpgFDBindlBteXUgt+UvJTAbETUTueFz+YvKwlZa8YnRjVmtNalxtT8qpwS+m5GkvZIKz/kBFifQQlbH8kwE6zg4+ZK5I8jh3kPdwf5LeRz1X7UkmRTSMo1czJpHu4cRVw/mHJqkAS8InyRAnQAGlOKdmxjTXp1ct9ftG9E=
701a0bd3-fee9-4f19-ace6-1f1eb5470978	402bd4aa-5452-479e-9661-a99bedd6a2f8	privateKey	MIIEogIBAAKCAQEAq/aM0tCotbrWDcYXD0Xj6KuJCU4ZrNIRgsQ4QLr+CM9wYrvijaYHK03zZr6+GzNWHUUrLwwUAjhBJqNlVBVmTTsU2DdefOLaX7fMV8xZ9pAvnm0430Z4/rlCa7tHOCwFz2jfKzI1DQDSYA8ZNFPr6ypQjzY/XBPcqlTe1wAJremRkyVMmMZmTsXaasnViN39MS69qNhzNJu5ksDOww3ZNyhysrUtXUILaP+u/xpSC3gHJBZB99hlUjXva+yTQajmN2SRgSGH0dbrUFjL/dC0jUUxkRLzXnF8btn3R5ToLC4pr3zjzfAOad4XbT/LkQ2G8BIm5Upj98dOclLF/U7mKwIDAQABAoIBAC+jFjHUYdguENwx8vNlLhSnaEfuncg1TWqHRvoPkw4HwR9o4wLQao4BgxsEXg+U8hcbsTHQS76trMayXwCjCPr+EfEvrXo1Mb9wYCg2UPmvybE+mpGnqR8PXSoQ8FLMRzPE3oXN28plXuIDbL0FPoaf6z8xDO5KBkgdSLoQpZ3Kb+wf53bXpuedHDO08PbowZAkOuFbNjSRRvQzKff7mX85uU1NZQhZc2bYL36xGPZWcfN4MWYJd1DKUH+g0rM5ml1D3hFN0JKYxudTKec00/vQ4FV5TK1OtxgZli+EglNsKLZXBfUU9nrOPdJjPXocq+KmDefckXUM0R9gXBzbDtkCgYEA8vmMGBETWt/6k64WEYcKx6G6Gkf4p1T8GVCCDejv0mkaFwAm8hhkdIeZocAU9j7hSdNCO3zhA+2WSgy01QZ307xriNNeIomCPB0pVcP7SfAE7BewG2ay/EYTKnNtJ1t4fGwplYrPsgOPUsI5qb19h/1fw0qkAP3PFtW0G5MxQs0CgYEAtS56JZ1w8ZUQO1ikE3s5BkDuYlnzDNbKJYwBNw6UDr8B5lYPAmdysdnjhA+tG0gpmGMO+4yJr3OTX8ymRk2hmjPRH7ssvpO8qBd58//0I7E4QpCAovCwLsIK6sNkzDlJ2JoQKuj3jzVE3+4dW6m1j3oJgpWxonMT1ph3pFHm/NcCgYAT+cg2wlChDAEB2zIdRsjwGK/AMWKT/zyqqB/JHPl6hwGKGo0ZIkBABFXxImWWyRykgSXU1jN5qzLL67eCPAHl+nusyBPZKwz1/D/FuVMThRQihOAJoKveabRxrQOwVKjXMd1JWhwxOnGyEB3FgrqrT31sBNru6e74paElEzjdkQKBgH24toGLcmfwa8cChzgNdVBllgUhLYpnMPZE5EL0FsD0wbi3VsrwRaIr87gbuJ8Jv/NCKY9bwd7BcC41r9tw2wZJln9SPoYvteVeBP3PSfXKb6Og6eIm6dpIQ5ML6tHbnuZyYW2lIsN4z0Yj0LNeW+InaJn4jb6P4+AxBDQ9sO8ZAoGAWv6MWCsE2d1rOEknkVRDuiSqfLiGxbOsKzoijfhwsV5/ygDNLAYxMj8e7SOZ7uGPFaneYfjcA48XlYRC6Y6DOK7zg/X5Wqh2ttFiRWrQjaS8UoCkg+WrRK8D5VUe+3kONACAEki3xN8j7fz+G+6wt33NsMHmlKUafDEuALywHNw=
e77ef18c-ef04-4317-b951-98a88abb7b82	402bd4aa-5452-479e-9661-a99bedd6a2f8	priority	100
3fbed10f-c7e7-475c-bb78-8cbc951f6204	cc07f4d9-5067-459a-b727-13e2cf71877b	secret	mWI3Vympuo_eOgiSB7xZTQ
6652582f-e0a4-4562-8f74-d86a46d3a299	cc07f4d9-5067-459a-b727-13e2cf71877b	priority	100
0c44b183-2974-4f34-ad85-baa913342ce2	cc07f4d9-5067-459a-b727-13e2cf71877b	kid	52a59c6f-cc0a-4c24-8755-379deb5be760
7940abf9-74a4-426e-82d9-eb913333ec67	38b57918-6bc5-4025-b957-b909cf07bfa1	kid	f9ca221b-80c9-4d13-9a0c-96de6e7467fe
5979074a-4b84-4870-853c-da88cf984d5b	38b57918-6bc5-4025-b957-b909cf07bfa1	secret	lnI_WOYXcFXgccMJjSBQltJp_EdW4MWgTlkBlsT_IRb_IQnWNMRNaWys7_Cox4wpL9FuScZMRMhkwW10_KeQ3w
c6753f98-b3cb-4171-be87-888420d0fd55	38b57918-6bc5-4025-b957-b909cf07bfa1	priority	100
59aa4aa1-c00a-418e-b1f6-a3a55e376ad4	38b57918-6bc5-4025-b957-b909cf07bfa1	algorithm	HS256
\.


--
-- Data for Name: composite_role; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.composite_role (composite, child_role) FROM stdin;
2872d781-3448-4ce1-afba-a83a00fc0cd5	780603d9-200c-45ee-b9ab-a43b14385214
2872d781-3448-4ce1-afba-a83a00fc0cd5	d6021cc3-f4a6-4367-b0e3-e94ebb786ffc
2872d781-3448-4ce1-afba-a83a00fc0cd5	3415bc40-a0da-419c-b8c6-03521e2b98f9
2872d781-3448-4ce1-afba-a83a00fc0cd5	593f5b03-7659-44bc-a4fb-72f2190f715e
2872d781-3448-4ce1-afba-a83a00fc0cd5	9676e5ab-22b8-4d2e-a3ab-1da3556f18f4
2872d781-3448-4ce1-afba-a83a00fc0cd5	ebe53840-ab98-4e8c-8b4e-3a2be556a5ae
2872d781-3448-4ce1-afba-a83a00fc0cd5	a90916d3-975e-4dd6-a35d-f19006a1869b
2872d781-3448-4ce1-afba-a83a00fc0cd5	6a1caa1d-48b8-4f0d-a0c6-2003cdf5b00d
2872d781-3448-4ce1-afba-a83a00fc0cd5	479b36c2-e836-4a8d-a03c-d71731f5d3ae
2872d781-3448-4ce1-afba-a83a00fc0cd5	ac8233ef-d787-4eff-8755-65572fc74e14
2872d781-3448-4ce1-afba-a83a00fc0cd5	8627ef1b-e95a-4606-be62-8657789d7b11
2872d781-3448-4ce1-afba-a83a00fc0cd5	a7da3cf3-b3e8-4fd6-868b-9d316730e598
2872d781-3448-4ce1-afba-a83a00fc0cd5	a51a45bf-a3b9-49d8-b465-066bec8d1f78
2872d781-3448-4ce1-afba-a83a00fc0cd5	9ff4e995-2a8f-4a0b-8b80-f1a3d44cf065
2872d781-3448-4ce1-afba-a83a00fc0cd5	c518dc6a-a190-42bc-b489-4e8db59cd57b
2872d781-3448-4ce1-afba-a83a00fc0cd5	3b4a8722-fd93-43ca-bbd2-7a15e6d36f06
2872d781-3448-4ce1-afba-a83a00fc0cd5	c3afd515-9f7d-4046-8fa8-3c4fe8e5c980
2872d781-3448-4ce1-afba-a83a00fc0cd5	38764b3c-0d72-4b38-be85-7471fa8431ce
9676e5ab-22b8-4d2e-a3ab-1da3556f18f4	3b4a8722-fd93-43ca-bbd2-7a15e6d36f06
593f5b03-7659-44bc-a4fb-72f2190f715e	38764b3c-0d72-4b38-be85-7471fa8431ce
593f5b03-7659-44bc-a4fb-72f2190f715e	c518dc6a-a190-42bc-b489-4e8db59cd57b
3d5c281f-5f5f-456b-9b69-4ffb578d5c91	ba071797-6bbe-4f25-86ad-52ed09ac301f
3d5c281f-5f5f-456b-9b69-4ffb578d5c91	38c5d434-0cfd-4a31-8eec-f4d33605e7d1
38c5d434-0cfd-4a31-8eec-f4d33605e7d1	eee694ed-0136-463d-9bfa-bc0d23170d8c
42637728-cf1c-4b3f-b7a2-274583911162	ab84fd83-b82f-4bbe-85dc-16b03ab08c48
2872d781-3448-4ce1-afba-a83a00fc0cd5	9d630250-43be-4a83-b257-cabacccf755d
3d5c281f-5f5f-456b-9b69-4ffb578d5c91	7dfc5846-32ce-4618-a35f-f790987a452b
3d5c281f-5f5f-456b-9b69-4ffb578d5c91	a44f3d84-0076-4dad-bd84-39daa14d4a67
\.


--
-- Data for Name: credential; Type: TABLE DATA; Schema: public; Owner: dba
-- original value 
-- c6d8cc34-28e7-4bc6-8e84-41855515d9c5	\N	password	9e60a853-0467-432d-af86-25dd3eb2f227	1621763827662	\N	{"value":"1gpGkFLpeiGmD9loZZByNjnFCm57JA6ex9L/smEPnw15NmD3GICexf3aFJmDcQ7NYrn0X32CItRVNVb1nQyxFw==","salt":"Kr07TZMv5O0XELEFDQCuVQ==","additionalParameters":{}}	{"hashIterations":100000,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
--

COPY public.credential (id, salt, type, user_id, created_date, user_label, secret_data, credential_data, priority) FROM stdin;
c6d8cc34-28e7-4bc6-8e84-41855515d9c5	\N	password	9e60a853-0467-432d-af86-25dd3eb2f227	1621763827662	\N	{"value":"0eUmSm/1N6iiE/QFGURZn2zgtPxOD0sh5zPBB4taDT+XJcG7BTcr+IsVfTkEOGlkMfWftVeA11ZXmFoCGn0sXA==","salt":"krBXzBh5PJPrv9ZLDpK+mA==","additionalParameters":{}}	{"hashIterations":27500,"algorithm":"pbkdf2-sha256","additionalParameters":{}}	10
\.


--
-- Data for Name: databasechangelog; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.databasechangelog (id, author, filename, dateexecuted, orderexecuted, exectype, md5sum, description, comments, tag, liquibase, contexts, labels, deployment_id) FROM stdin;
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/jpa-changelog-1.0.0.Final.xml	2021-05-23 09:56:55.300918	1	EXECUTED	7:4e70412f24a3f382c82183742ec79317	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	3.5.4	\N	\N	1763814917
1.0.0.Final-KEYCLOAK-5461	sthorger@redhat.com	META-INF/db2-jpa-changelog-1.0.0.Final.xml	2021-05-23 09:56:55.315786	2	MARK_RAN	7:cb16724583e9675711801c6875114f28	createTable tableName=APPLICATION_DEFAULT_ROLES; createTable tableName=CLIENT; createTable tableName=CLIENT_SESSION; createTable tableName=CLIENT_SESSION_ROLE; createTable tableName=COMPOSITE_ROLE; createTable tableName=CREDENTIAL; createTable tab...		\N	3.5.4	\N	\N	1763814917
1.1.0.Beta1	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Beta1.xml	2021-05-23 09:56:55.405688	3	EXECUTED	7:0310eb8ba07cec616460794d42ade0fa	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=CLIENT_ATTRIBUTES; createTable tableName=CLIENT_SESSION_NOTE; createTable tableName=APP_NODE_REGISTRATIONS; addColumn table...		\N	3.5.4	\N	\N	1763814917
1.1.0.Final	sthorger@redhat.com	META-INF/jpa-changelog-1.1.0.Final.xml	2021-05-23 09:56:55.41266	4	EXECUTED	7:5d25857e708c3233ef4439df1f93f012	renameColumn newColumnName=EVENT_TIME, oldColumnName=TIME, tableName=EVENT_ENTITY		\N	3.5.4	\N	\N	1763814917
1.2.0.Beta1	psilva@redhat.com	META-INF/jpa-changelog-1.2.0.Beta1.xml	2021-05-23 09:56:55.59696	5	EXECUTED	7:c7a54a1041d58eb3817a4a883b4d4e84	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	3.5.4	\N	\N	1763814917
1.2.0.Beta1	psilva@redhat.com	META-INF/db2-jpa-changelog-1.2.0.Beta1.xml	2021-05-23 09:56:55.602336	6	MARK_RAN	7:2e01012df20974c1c2a605ef8afe25b7	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION; createTable tableName=PROTOCOL_MAPPER; createTable tableName=PROTOCOL_MAPPER_CONFIG; createTable tableName=...		\N	3.5.4	\N	\N	1763814917
1.2.0.RC1	bburke@redhat.com	META-INF/jpa-changelog-1.2.0.CR1.xml	2021-05-23 09:56:55.877792	7	EXECUTED	7:0f08df48468428e0f30ee59a8ec01a41	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	3.5.4	\N	\N	1763814917
1.2.0.RC1	bburke@redhat.com	META-INF/db2-jpa-changelog-1.2.0.CR1.xml	2021-05-23 09:56:55.888621	8	MARK_RAN	7:a77ea2ad226b345e7d689d366f185c8c	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=MIGRATION_MODEL; createTable tableName=IDENTITY_P...		\N	3.5.4	\N	\N	1763814917
1.2.0.Final	keycloak	META-INF/jpa-changelog-1.2.0.Final.xml	2021-05-23 09:56:55.899107	9	EXECUTED	7:a3377a2059aefbf3b90ebb4c4cc8e2ab	update tableName=CLIENT; update tableName=CLIENT; update tableName=CLIENT		\N	3.5.4	\N	\N	1763814917
1.3.0	bburke@redhat.com	META-INF/jpa-changelog-1.3.0.xml	2021-05-23 09:56:56.054021	10	EXECUTED	7:04c1dbedc2aa3e9756d1a1668e003451	delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete tableName=USER_SESSION; createTable tableName=ADMI...		\N	3.5.4	\N	\N	1763814917
1.4.0	bburke@redhat.com	META-INF/jpa-changelog-1.4.0.xml	2021-05-23 09:56:56.140023	11	EXECUTED	7:36ef39ed560ad07062d956db861042ba	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	1763814917
1.4.0	bburke@redhat.com	META-INF/db2-jpa-changelog-1.4.0.xml	2021-05-23 09:56:56.142697	12	MARK_RAN	7:d909180b2530479a716d3f9c9eaea3d7	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	1763814917
1.5.0	bburke@redhat.com	META-INF/jpa-changelog-1.5.0.xml	2021-05-23 09:56:56.268747	13	EXECUTED	7:cf12b04b79bea5152f165eb41f3955f6	delete tableName=CLIENT_SESSION_AUTH_STATUS; delete tableName=CLIENT_SESSION_ROLE; delete tableName=CLIENT_SESSION_PROT_MAPPER; delete tableName=CLIENT_SESSION_NOTE; delete tableName=CLIENT_SESSION; delete tableName=USER_SESSION_NOTE; delete table...		\N	3.5.4	\N	\N	1763814917
1.6.1_from15	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-05-23 09:56:56.329568	14	EXECUTED	7:7e32c8f05c755e8675764e7d5f514509	addColumn tableName=REALM; addColumn tableName=KEYCLOAK_ROLE; addColumn tableName=CLIENT; createTable tableName=OFFLINE_USER_SESSION; createTable tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_US_SES_PK2, tableName=...		\N	3.5.4	\N	\N	1763814917
1.6.1_from16-pre	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-05-23 09:56:56.331511	15	MARK_RAN	7:980ba23cc0ec39cab731ce903dd01291	delete tableName=OFFLINE_CLIENT_SESSION; delete tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	1763814917
1.6.1_from16	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-05-23 09:56:56.333636	16	MARK_RAN	7:2fa220758991285312eb84f3b4ff5336	dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_US_SES_PK, tableName=OFFLINE_USER_SESSION; dropPrimaryKey constraintName=CONSTRAINT_OFFLINE_CL_SES_PK, tableName=OFFLINE_CLIENT_SESSION; addColumn tableName=OFFLINE_USER_SESSION; update tableName=OF...		\N	3.5.4	\N	\N	1763814917
1.6.1	mposolda@redhat.com	META-INF/jpa-changelog-1.6.1.xml	2021-05-23 09:56:56.335495	17	EXECUTED	7:d41d8cd98f00b204e9800998ecf8427e	empty		\N	3.5.4	\N	\N	1763814917
1.7.0	bburke@redhat.com	META-INF/jpa-changelog-1.7.0.xml	2021-05-23 09:56:56.424648	18	EXECUTED	7:91ace540896df890cc00a0490ee52bbc	createTable tableName=KEYCLOAK_GROUP; createTable tableName=GROUP_ROLE_MAPPING; createTable tableName=GROUP_ATTRIBUTE; createTable tableName=USER_GROUP_MEMBERSHIP; createTable tableName=REALM_DEFAULT_GROUPS; addColumn tableName=IDENTITY_PROVIDER; ...		\N	3.5.4	\N	\N	1763814917
1.8.0	mposolda@redhat.com	META-INF/jpa-changelog-1.8.0.xml	2021-05-23 09:56:56.508769	19	EXECUTED	7:c31d1646dfa2618a9335c00e07f89f24	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	3.5.4	\N	\N	1763814917
1.8.0-2	keycloak	META-INF/jpa-changelog-1.8.0.xml	2021-05-23 09:56:56.51619	20	EXECUTED	7:df8bc21027a4f7cbbb01f6344e89ce07	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	3.5.4	\N	\N	1763814917
authz-3.4.0.CR1-resource-server-pk-change-part1	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-05-23 09:56:58.250726	45	EXECUTED	7:6a48ce645a3525488a90fbf76adf3bb3	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_RESOURCE; addColumn tableName=RESOURCE_SERVER_SCOPE		\N	3.5.4	\N	\N	1763814917
1.8.0	mposolda@redhat.com	META-INF/db2-jpa-changelog-1.8.0.xml	2021-05-23 09:56:56.518731	21	MARK_RAN	7:f987971fe6b37d963bc95fee2b27f8df	addColumn tableName=IDENTITY_PROVIDER; createTable tableName=CLIENT_TEMPLATE; createTable tableName=CLIENT_TEMPLATE_ATTRIBUTES; createTable tableName=TEMPLATE_SCOPE_MAPPING; dropNotNullConstraint columnName=CLIENT_ID, tableName=PROTOCOL_MAPPER; ad...		\N	3.5.4	\N	\N	1763814917
1.8.0-2	keycloak	META-INF/db2-jpa-changelog-1.8.0.xml	2021-05-23 09:56:56.522184	22	MARK_RAN	7:df8bc21027a4f7cbbb01f6344e89ce07	dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; update tableName=CREDENTIAL		\N	3.5.4	\N	\N	1763814917
1.9.0	mposolda@redhat.com	META-INF/jpa-changelog-1.9.0.xml	2021-05-23 09:56:56.606557	23	EXECUTED	7:ed2dc7f799d19ac452cbcda56c929e47	update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=REALM; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=REALM; update tableName=REALM; customChange; dr...		\N	3.5.4	\N	\N	1763814917
1.9.1	keycloak	META-INF/jpa-changelog-1.9.1.xml	2021-05-23 09:56:56.611951	24	EXECUTED	7:80b5db88a5dda36ece5f235be8757615	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=PUBLIC_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	3.5.4	\N	\N	1763814917
1.9.1	keycloak	META-INF/db2-jpa-changelog-1.9.1.xml	2021-05-23 09:56:56.613746	25	MARK_RAN	7:1437310ed1305a9b93f8848f301726ce	modifyDataType columnName=PRIVATE_KEY, tableName=REALM; modifyDataType columnName=CERTIFICATE, tableName=REALM		\N	3.5.4	\N	\N	1763814917
1.9.2	keycloak	META-INF/jpa-changelog-1.9.2.xml	2021-05-23 09:56:56.912719	26	EXECUTED	7:b82ffb34850fa0836be16deefc6a87c4	createIndex indexName=IDX_USER_EMAIL, tableName=USER_ENTITY; createIndex indexName=IDX_USER_ROLE_MAPPING, tableName=USER_ROLE_MAPPING; createIndex indexName=IDX_USER_GROUP_MAPPING, tableName=USER_GROUP_MEMBERSHIP; createIndex indexName=IDX_USER_CO...		\N	3.5.4	\N	\N	1763814917
authz-2.0.0	psilva@redhat.com	META-INF/jpa-changelog-authz-2.0.0.xml	2021-05-23 09:56:56.995639	27	EXECUTED	7:9cc98082921330d8d9266decdd4bd658	createTable tableName=RESOURCE_SERVER; addPrimaryKey constraintName=CONSTRAINT_FARS, tableName=RESOURCE_SERVER; addUniqueConstraint constraintName=UK_AU8TT6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER; createTable tableName=RESOURCE_SERVER_RESOU...		\N	3.5.4	\N	\N	1763814917
authz-2.5.1	psilva@redhat.com	META-INF/jpa-changelog-authz-2.5.1.xml	2021-05-23 09:56:56.999384	28	EXECUTED	7:03d64aeed9cb52b969bd30a7ac0db57e	update tableName=RESOURCE_SERVER_POLICY		\N	3.5.4	\N	\N	1763814917
2.1.0-KEYCLOAK-5461	bburke@redhat.com	META-INF/jpa-changelog-2.1.0.xml	2021-05-23 09:56:57.073174	29	EXECUTED	7:f1f9fd8710399d725b780f463c6b21cd	createTable tableName=BROKER_LINK; createTable tableName=FED_USER_ATTRIBUTE; createTable tableName=FED_USER_CONSENT; createTable tableName=FED_USER_CONSENT_ROLE; createTable tableName=FED_USER_CONSENT_PROT_MAPPER; createTable tableName=FED_USER_CR...		\N	3.5.4	\N	\N	1763814917
2.2.0	bburke@redhat.com	META-INF/jpa-changelog-2.2.0.xml	2021-05-23 09:56:57.08421	30	EXECUTED	7:53188c3eb1107546e6f765835705b6c1	addColumn tableName=ADMIN_EVENT_ENTITY; createTable tableName=CREDENTIAL_ATTRIBUTE; createTable tableName=FED_CREDENTIAL_ATTRIBUTE; modifyDataType columnName=VALUE, tableName=CREDENTIAL; addForeignKeyConstraint baseTableName=FED_CREDENTIAL_ATTRIBU...		\N	3.5.4	\N	\N	1763814917
2.3.0	bburke@redhat.com	META-INF/jpa-changelog-2.3.0.xml	2021-05-23 09:56:57.10482	31	EXECUTED	7:d6e6f3bc57a0c5586737d1351725d4d4	createTable tableName=FEDERATED_USER; addPrimaryKey constraintName=CONSTR_FEDERATED_USER, tableName=FEDERATED_USER; dropDefaultValue columnName=TOTP, tableName=USER_ENTITY; dropColumn columnName=TOTP, tableName=USER_ENTITY; addColumn tableName=IDE...		\N	3.5.4	\N	\N	1763814917
2.4.0	bburke@redhat.com	META-INF/jpa-changelog-2.4.0.xml	2021-05-23 09:56:57.110063	32	EXECUTED	7:454d604fbd755d9df3fd9c6329043aa5	customChange		\N	3.5.4	\N	\N	1763814917
2.5.0	bburke@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-05-23 09:56:57.11503	33	EXECUTED	7:57e98a3077e29caf562f7dbf80c72600	customChange; modifyDataType columnName=USER_ID, tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	1763814917
2.5.0-unicode-oracle	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-05-23 09:56:57.119956	34	MARK_RAN	7:e4c7e8f2256210aee71ddc42f538b57a	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	3.5.4	\N	\N	1763814917
2.5.0-unicode-other-dbs	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-05-23 09:56:57.141215	35	EXECUTED	7:09a43c97e49bc626460480aa1379b522	modifyDataType columnName=DESCRIPTION, tableName=AUTHENTICATION_FLOW; modifyDataType columnName=DESCRIPTION, tableName=CLIENT_TEMPLATE; modifyDataType columnName=DESCRIPTION, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=DESCRIPTION,...		\N	3.5.4	\N	\N	1763814917
2.5.0-duplicate-email-support	slawomir@dabek.name	META-INF/jpa-changelog-2.5.0.xml	2021-05-23 09:56:57.162652	36	EXECUTED	7:26bfc7c74fefa9126f2ce702fb775553	addColumn tableName=REALM		\N	3.5.4	\N	\N	1763814917
2.5.0-unique-group-names	hmlnarik@redhat.com	META-INF/jpa-changelog-2.5.0.xml	2021-05-23 09:56:57.172032	37	EXECUTED	7:a161e2ae671a9020fff61e996a207377	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	1763814917
2.5.1	bburke@redhat.com	META-INF/jpa-changelog-2.5.1.xml	2021-05-23 09:56:57.17542	38	EXECUTED	7:37fc1781855ac5388c494f1442b3f717	addColumn tableName=FED_USER_CONSENT		\N	3.5.4	\N	\N	1763814917
3.0.0	bburke@redhat.com	META-INF/jpa-changelog-3.0.0.xml	2021-05-23 09:56:57.185289	39	EXECUTED	7:13a27db0dae6049541136adad7261d27	addColumn tableName=IDENTITY_PROVIDER		\N	3.5.4	\N	\N	1763814917
3.2.0-fix	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-05-23 09:56:57.187213	40	MARK_RAN	7:550300617e3b59e8af3a6294df8248a3	addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS		\N	3.5.4	\N	\N	1763814917
3.2.0-fix-with-keycloak-5416	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-05-23 09:56:57.188889	41	MARK_RAN	7:e3a9482b8931481dc2772a5c07c44f17	dropIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS; addNotNullConstraint columnName=REALM_ID, tableName=CLIENT_INITIAL_ACCESS; createIndex indexName=IDX_CLIENT_INIT_ACC_REALM, tableName=CLIENT_INITIAL_ACCESS		\N	3.5.4	\N	\N	1763814917
3.2.0-fix-offline-sessions	hmlnarik	META-INF/jpa-changelog-3.2.0.xml	2021-05-23 09:56:57.192718	42	EXECUTED	7:72b07d85a2677cb257edb02b408f332d	customChange		\N	3.5.4	\N	\N	1763814917
3.2.0-fixed	keycloak	META-INF/jpa-changelog-3.2.0.xml	2021-05-23 09:56:58.13472	43	EXECUTED	7:a72a7858967bd414835d19e04d880312	addColumn tableName=REALM; dropPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_PK2, tableName=OFFLINE_CLIENT_SESSION; dropColumn columnName=CLIENT_SESSION_ID, tableName=OFFLINE_CLIENT_SESSION; addPrimaryKey constraintName=CONSTRAINT_OFFL_CL_SES_P...		\N	3.5.4	\N	\N	1763814917
3.3.0	keycloak	META-INF/jpa-changelog-3.3.0.xml	2021-05-23 09:56:58.217049	44	EXECUTED	7:94edff7cf9ce179e7e85f0cd78a3cf2c	addColumn tableName=USER_ENTITY		\N	3.5.4	\N	\N	1763814917
authz-3.4.0.CR1-resource-server-pk-change-part2-KEYCLOAK-6095	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-05-23 09:56:58.260186	46	EXECUTED	7:e64b5dcea7db06077c6e57d3b9e5ca14	customChange		\N	3.5.4	\N	\N	1763814917
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-05-23 09:56:58.26203	47	MARK_RAN	7:fd8cf02498f8b1e72496a20afc75178c	dropIndex indexName=IDX_RES_SERV_POL_RES_SERV, tableName=RESOURCE_SERVER_POLICY; dropIndex indexName=IDX_RES_SRV_RES_RES_SRV, tableName=RESOURCE_SERVER_RESOURCE; dropIndex indexName=IDX_RES_SRV_SCOPE_RES_SRV, tableName=RESOURCE_SERVER_SCOPE		\N	3.5.4	\N	\N	1763814917
authz-3.4.0.CR1-resource-server-pk-change-part3-fixed-nodropindex	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-05-23 09:56:58.344667	48	EXECUTED	7:542794f25aa2b1fbabb7e577d6646319	addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_POLICY; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, tableName=RESOURCE_SERVER_RESOURCE; addNotNullConstraint columnName=RESOURCE_SERVER_CLIENT_ID, ...		\N	3.5.4	\N	\N	1763814917
authn-3.4.0.CR1-refresh-token-max-reuse	glavoie@gmail.com	META-INF/jpa-changelog-authz-3.4.0.CR1.xml	2021-05-23 09:56:58.360741	49	EXECUTED	7:edad604c882df12f74941dac3cc6d650	addColumn tableName=REALM		\N	3.5.4	\N	\N	1763814917
3.4.0	keycloak	META-INF/jpa-changelog-3.4.0.xml	2021-05-23 09:56:58.410714	50	EXECUTED	7:0f88b78b7b46480eb92690cbf5e44900	addPrimaryKey constraintName=CONSTRAINT_REALM_DEFAULT_ROLES, tableName=REALM_DEFAULT_ROLES; addPrimaryKey constraintName=CONSTRAINT_COMPOSITE_ROLE, tableName=COMPOSITE_ROLE; addPrimaryKey constraintName=CONSTR_REALM_DEFAULT_GROUPS, tableName=REALM...		\N	3.5.4	\N	\N	1763814917
3.4.0-KEYCLOAK-5230	hmlnarik@redhat.com	META-INF/jpa-changelog-3.4.0.xml	2021-05-23 09:56:58.688876	51	EXECUTED	7:d560e43982611d936457c327f872dd59	createIndex indexName=IDX_FU_ATTRIBUTE, tableName=FED_USER_ATTRIBUTE; createIndex indexName=IDX_FU_CONSENT, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CONSENT_RU, tableName=FED_USER_CONSENT; createIndex indexName=IDX_FU_CREDENTIAL, t...		\N	3.5.4	\N	\N	1763814917
3.4.1	psilva@redhat.com	META-INF/jpa-changelog-3.4.1.xml	2021-05-23 09:56:58.693155	52	EXECUTED	7:c155566c42b4d14ef07059ec3b3bbd8e	modifyDataType columnName=VALUE, tableName=CLIENT_ATTRIBUTES		\N	3.5.4	\N	\N	1763814917
3.4.2	keycloak	META-INF/jpa-changelog-3.4.2.xml	2021-05-23 09:56:58.696711	53	EXECUTED	7:b40376581f12d70f3c89ba8ddf5b7dea	update tableName=REALM		\N	3.5.4	\N	\N	1763814917
3.4.2-KEYCLOAK-5172	mkanis@redhat.com	META-INF/jpa-changelog-3.4.2.xml	2021-05-23 09:56:58.700696	54	EXECUTED	7:a1132cc395f7b95b3646146c2e38f168	update tableName=CLIENT		\N	3.5.4	\N	\N	1763814917
4.0.0-KEYCLOAK-6335	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-05-23 09:56:58.707067	55	EXECUTED	7:d8dc5d89c789105cfa7ca0e82cba60af	createTable tableName=CLIENT_AUTH_FLOW_BINDINGS; addPrimaryKey constraintName=C_CLI_FLOW_BIND, tableName=CLIENT_AUTH_FLOW_BINDINGS		\N	3.5.4	\N	\N	1763814917
4.0.0-CLEANUP-UNUSED-TABLE	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-05-23 09:56:58.711472	56	EXECUTED	7:7822e0165097182e8f653c35517656a3	dropTable tableName=CLIENT_IDENTITY_PROV_MAPPING		\N	3.5.4	\N	\N	1763814917
4.0.0-KEYCLOAK-6228	bburke@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-05-23 09:56:58.759342	57	EXECUTED	7:c6538c29b9c9a08f9e9ea2de5c2b6375	dropUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHOGM8UEWRT, tableName=USER_CONSENT; dropNotNullConstraint columnName=CLIENT_ID, tableName=USER_CONSENT; addColumn tableName=USER_CONSENT; addUniqueConstraint constraintName=UK_JKUWUVD56ONTGSUHO...		\N	3.5.4	\N	\N	1763814917
4.0.0-KEYCLOAK-5579-fixed	mposolda@redhat.com	META-INF/jpa-changelog-4.0.0.xml	2021-05-23 09:56:59.022168	58	EXECUTED	7:6d4893e36de22369cf73bcb051ded875	dropForeignKeyConstraint baseTableName=CLIENT_TEMPLATE_ATTRIBUTES, constraintName=FK_CL_TEMPL_ATTR_TEMPL; renameTable newTableName=CLIENT_SCOPE_ATTRIBUTES, oldTableName=CLIENT_TEMPLATE_ATTRIBUTES; renameColumn newColumnName=SCOPE_ID, oldColumnName...		\N	3.5.4	\N	\N	1763814917
authz-4.0.0.CR1	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.CR1.xml	2021-05-23 09:56:59.074444	59	EXECUTED	7:57960fc0b0f0dd0563ea6f8b2e4a1707	createTable tableName=RESOURCE_SERVER_PERM_TICKET; addPrimaryKey constraintName=CONSTRAINT_FAPMT, tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRHO213XCX4WNKOG82SSPMT...		\N	3.5.4	\N	\N	1763814917
authz-4.0.0.Beta3	psilva@redhat.com	META-INF/jpa-changelog-authz-4.0.0.Beta3.xml	2021-05-23 09:56:59.080179	60	EXECUTED	7:2b4b8bff39944c7097977cc18dbceb3b	addColumn tableName=RESOURCE_SERVER_POLICY; addColumn tableName=RESOURCE_SERVER_PERM_TICKET; addForeignKeyConstraint baseTableName=RESOURCE_SERVER_PERM_TICKET, constraintName=FK_FRSRPO2128CX4WNKOG82SSRFY, referencedTableName=RESOURCE_SERVER_POLICY		\N	3.5.4	\N	\N	1763814917
authz-4.2.0.Final	mhajas@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2021-05-23 09:56:59.091431	61	EXECUTED	7:2aa42a964c59cd5b8ca9822340ba33a8	createTable tableName=RESOURCE_URIS; addForeignKeyConstraint baseTableName=RESOURCE_URIS, constraintName=FK_RESOURCE_SERVER_URIS, referencedTableName=RESOURCE_SERVER_RESOURCE; customChange; dropColumn columnName=URI, tableName=RESOURCE_SERVER_RESO...		\N	3.5.4	\N	\N	1763814917
authz-4.2.0.Final-KEYCLOAK-9944	hmlnarik@redhat.com	META-INF/jpa-changelog-authz-4.2.0.Final.xml	2021-05-23 09:56:59.097911	62	EXECUTED	7:9ac9e58545479929ba23f4a3087a0346	addPrimaryKey constraintName=CONSTRAINT_RESOUR_URIS_PK, tableName=RESOURCE_URIS		\N	3.5.4	\N	\N	1763814917
4.2.0-KEYCLOAK-6313	wadahiro@gmail.com	META-INF/jpa-changelog-4.2.0.xml	2021-05-23 09:56:59.101005	63	EXECUTED	7:14d407c35bc4fe1976867756bcea0c36	addColumn tableName=REQUIRED_ACTION_PROVIDER		\N	3.5.4	\N	\N	1763814917
4.3.0-KEYCLOAK-7984	wadahiro@gmail.com	META-INF/jpa-changelog-4.3.0.xml	2021-05-23 09:56:59.106429	64	EXECUTED	7:241a8030c748c8548e346adee548fa93	update tableName=REQUIRED_ACTION_PROVIDER		\N	3.5.4	\N	\N	1763814917
4.6.0-KEYCLOAK-7950	psilva@redhat.com	META-INF/jpa-changelog-4.6.0.xml	2021-05-23 09:56:59.109384	65	EXECUTED	7:7d3182f65a34fcc61e8d23def037dc3f	update tableName=RESOURCE_SERVER_RESOURCE		\N	3.5.4	\N	\N	1763814917
4.6.0-KEYCLOAK-8377	keycloak	META-INF/jpa-changelog-4.6.0.xml	2021-05-23 09:56:59.137815	66	EXECUTED	7:b30039e00a0b9715d430d1b0636728fa	createTable tableName=ROLE_ATTRIBUTE; addPrimaryKey constraintName=CONSTRAINT_ROLE_ATTRIBUTE_PK, tableName=ROLE_ATTRIBUTE; addForeignKeyConstraint baseTableName=ROLE_ATTRIBUTE, constraintName=FK_ROLE_ATTRIBUTE_ID, referencedTableName=KEYCLOAK_ROLE...		\N	3.5.4	\N	\N	1763814917
4.6.0-KEYCLOAK-8555	gideonray@gmail.com	META-INF/jpa-changelog-4.6.0.xml	2021-05-23 09:56:59.16118	67	EXECUTED	7:3797315ca61d531780f8e6f82f258159	createIndex indexName=IDX_COMPONENT_PROVIDER_TYPE, tableName=COMPONENT		\N	3.5.4	\N	\N	1763814917
4.7.0-KEYCLOAK-1267	sguilhen@redhat.com	META-INF/jpa-changelog-4.7.0.xml	2021-05-23 09:56:59.187538	68	EXECUTED	7:c7aa4c8d9573500c2d347c1941ff0301	addColumn tableName=REALM		\N	3.5.4	\N	\N	1763814917
4.7.0-KEYCLOAK-7275	keycloak	META-INF/jpa-changelog-4.7.0.xml	2021-05-23 09:56:59.218476	69	EXECUTED	7:b207faee394fc074a442ecd42185a5dd	renameColumn newColumnName=CREATED_ON, oldColumnName=LAST_SESSION_REFRESH, tableName=OFFLINE_USER_SESSION; addNotNullConstraint columnName=CREATED_ON, tableName=OFFLINE_USER_SESSION; addColumn tableName=OFFLINE_USER_SESSION; customChange; createIn...		\N	3.5.4	\N	\N	1763814917
4.8.0-KEYCLOAK-8835	sguilhen@redhat.com	META-INF/jpa-changelog-4.8.0.xml	2021-05-23 09:56:59.223013	70	EXECUTED	7:ab9a9762faaba4ddfa35514b212c4922	addNotNullConstraint columnName=SSO_MAX_LIFESPAN_REMEMBER_ME, tableName=REALM; addNotNullConstraint columnName=SSO_IDLE_TIMEOUT_REMEMBER_ME, tableName=REALM		\N	3.5.4	\N	\N	1763814917
authz-7.0.0-KEYCLOAK-10443	psilva@redhat.com	META-INF/jpa-changelog-authz-7.0.0.xml	2021-05-23 09:56:59.229938	71	EXECUTED	7:b9710f74515a6ccb51b72dc0d19df8c4	addColumn tableName=RESOURCE_SERVER		\N	3.5.4	\N	\N	1763814917
8.0.0-adding-credential-columns	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-05-23 09:56:59.235396	72	EXECUTED	7:ec9707ae4d4f0b7452fee20128083879	addColumn tableName=CREDENTIAL; addColumn tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	1763814917
8.0.0-updating-credential-data-not-oracle	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-05-23 09:56:59.243084	73	EXECUTED	7:03b3f4b264c3c68ba082250a80b74216	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	1763814917
8.0.0-updating-credential-data-oracle	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-05-23 09:56:59.247418	74	MARK_RAN	7:64c5728f5ca1f5aa4392217701c4fe23	update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL; update tableName=FED_USER_CREDENTIAL		\N	3.5.4	\N	\N	1763814917
8.0.0-credential-cleanup-fixed	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-05-23 09:56:59.262492	75	EXECUTED	7:b48da8c11a3d83ddd6b7d0c8c2219345	dropDefaultValue columnName=COUNTER, tableName=CREDENTIAL; dropDefaultValue columnName=DIGITS, tableName=CREDENTIAL; dropDefaultValue columnName=PERIOD, tableName=CREDENTIAL; dropDefaultValue columnName=ALGORITHM, tableName=CREDENTIAL; dropColumn ...		\N	3.5.4	\N	\N	1763814917
8.0.0-resource-tag-support	keycloak	META-INF/jpa-changelog-8.0.0.xml	2021-05-23 09:56:59.284735	76	EXECUTED	7:a73379915c23bfad3e8f5c6d5c0aa4bd	addColumn tableName=MIGRATION_MODEL; createIndex indexName=IDX_UPDATE_TIME, tableName=MIGRATION_MODEL		\N	3.5.4	\N	\N	1763814917
9.0.0-always-display-client	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-05-23 09:56:59.298558	77	EXECUTED	7:39e0073779aba192646291aa2332493d	addColumn tableName=CLIENT		\N	3.5.4	\N	\N	1763814917
9.0.0-drop-constraints-for-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-05-23 09:56:59.300378	78	MARK_RAN	7:81f87368f00450799b4bf42ea0b3ec34	dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5PMT, tableName=RESOURCE_SERVER_PERM_TICKET; dropUniqueConstraint constraintName=UK_FRSR6T700S9V50BU18WS5HA6, tableName=RESOURCE_SERVER_RESOURCE; dropPrimaryKey constraintName=CONSTRAINT_O...		\N	3.5.4	\N	\N	1763814917
9.0.0-increase-column-size-federated-fk	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-05-23 09:56:59.317623	79	EXECUTED	7:20b37422abb9fb6571c618148f013a15	modifyDataType columnName=CLIENT_ID, tableName=FED_USER_CONSENT; modifyDataType columnName=CLIENT_REALM_CONSTRAINT, tableName=KEYCLOAK_ROLE; modifyDataType columnName=OWNER, tableName=RESOURCE_SERVER_POLICY; modifyDataType columnName=CLIENT_ID, ta...		\N	3.5.4	\N	\N	1763814917
9.0.0-recreate-constraints-after-column-increase	keycloak	META-INF/jpa-changelog-9.0.0.xml	2021-05-23 09:56:59.319786	80	MARK_RAN	7:1970bb6cfb5ee800736b95ad3fb3c78a	addNotNullConstraint columnName=CLIENT_ID, tableName=OFFLINE_CLIENT_SESSION; addNotNullConstraint columnName=OWNER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNullConstraint columnName=REQUESTER, tableName=RESOURCE_SERVER_PERM_TICKET; addNotNull...		\N	3.5.4	\N	\N	1763814917
9.0.1-add-index-to-client.client_id	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-05-23 09:56:59.336757	81	EXECUTED	7:45d9b25fc3b455d522d8dcc10a0f4c80	createIndex indexName=IDX_CLIENT_ID, tableName=CLIENT		\N	3.5.4	\N	\N	1763814917
9.0.1-KEYCLOAK-12579-drop-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-05-23 09:56:59.339559	82	MARK_RAN	7:890ae73712bc187a66c2813a724d037f	dropUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	1763814917
9.0.1-KEYCLOAK-12579-add-not-null-constraint	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-05-23 09:56:59.342985	83	EXECUTED	7:0a211980d27fafe3ff50d19a3a29b538	addNotNullConstraint columnName=PARENT_GROUP, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	1763814917
9.0.1-KEYCLOAK-12579-recreate-constraints	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-05-23 09:56:59.344703	84	MARK_RAN	7:a161e2ae671a9020fff61e996a207377	addUniqueConstraint constraintName=SIBLING_NAMES, tableName=KEYCLOAK_GROUP		\N	3.5.4	\N	\N	1763814917
9.0.1-add-index-to-events	keycloak	META-INF/jpa-changelog-9.0.1.xml	2021-05-23 09:56:59.361642	85	EXECUTED	7:01c49302201bdf815b0a18d1f98a55dc	createIndex indexName=IDX_EVENT_TIME, tableName=EVENT_ENTITY		\N	3.5.4	\N	\N	1763814917
map-remove-ri	keycloak	META-INF/jpa-changelog-11.0.0.xml	2021-05-23 09:56:59.369549	86	EXECUTED	7:3dace6b144c11f53f1ad2c0361279b86	dropForeignKeyConstraint baseTableName=REALM, constraintName=FK_TRAF444KK6QRKMS7N56AIWQ5Y; dropForeignKeyConstraint baseTableName=KEYCLOAK_ROLE, constraintName=FK_KJHO5LE2C0RAL09FL8CM9WFW9		\N	3.5.4	\N	\N	1763814917
map-remove-ri	keycloak	META-INF/jpa-changelog-12.0.0.xml	2021-05-23 09:56:59.376675	87	EXECUTED	7:578d0b92077eaf2ab95ad0ec087aa903	dropForeignKeyConstraint baseTableName=REALM_DEFAULT_GROUPS, constraintName=FK_DEF_GROUPS_GROUP; dropForeignKeyConstraint baseTableName=REALM_DEFAULT_ROLES, constraintName=FK_H4WPD7W4HSOOLNI3H0SW7BTJE; dropForeignKeyConstraint baseTableName=CLIENT...		\N	3.5.4	\N	\N	1763814917
12.1.0-add-realm-localization-table	keycloak	META-INF/jpa-changelog-12.0.0.xml	2021-05-23 09:56:59.385884	88	EXECUTED	7:c95abe90d962c57a09ecaee57972835d	createTable tableName=REALM_LOCALIZATIONS; addPrimaryKey tableName=REALM_LOCALIZATIONS		\N	3.5.4	\N	\N	1763814917
default-roles	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-05-23 09:56:59.391504	89	EXECUTED	7:f1313bcc2994a5c4dc1062ed6d8282d3	addColumn tableName=REALM; customChange		\N	3.5.4	\N	\N	1763814917
default-roles-cleanup	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-05-23 09:56:59.398149	90	EXECUTED	7:90d763b52eaffebefbcbde55f269508b	dropTable tableName=REALM_DEFAULT_ROLES; dropTable tableName=CLIENT_DEFAULT_ROLES		\N	3.5.4	\N	\N	1763814917
13.0.0-KEYCLOAK-16844	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-05-23 09:56:59.468434	91	EXECUTED	7:d554f0cb92b764470dccfa5e0014a7dd	createIndex indexName=IDX_OFFLINE_USS_PRELOAD, tableName=OFFLINE_USER_SESSION		\N	3.5.4	\N	\N	1763814917
map-remove-ri-13.0.0	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-05-23 09:56:59.47735	92	EXECUTED	7:73193e3ab3c35cf0f37ccea3bf783764	dropForeignKeyConstraint baseTableName=DEFAULT_CLIENT_SCOPE, constraintName=FK_R_DEF_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SCOPE_CLIENT, constraintName=FK_C_CLI_SCOPE_SCOPE; dropForeignKeyConstraint baseTableName=CLIENT_SC...		\N	3.5.4	\N	\N	1763814917
13.0.0-KEYCLOAK-17992-drop-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-05-23 09:56:59.479676	93	MARK_RAN	7:90a1e74f92e9cbaa0c5eab80b8a037f3	dropPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CLSCOPE_CL, tableName=CLIENT_SCOPE_CLIENT; dropIndex indexName=IDX_CL_CLSCOPE, tableName=CLIENT_SCOPE_CLIENT		\N	3.5.4	\N	\N	1763814917
13.0.0-increase-column-size-federated	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-05-23 09:56:59.488085	94	EXECUTED	7:5b9248f29cd047c200083cc6d8388b16	modifyDataType columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; modifyDataType columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT		\N	3.5.4	\N	\N	1763814917
13.0.0-KEYCLOAK-17992-recreate-constraints	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-05-23 09:56:59.490361	95	MARK_RAN	7:64db59e44c374f13955489e8990d17a1	addNotNullConstraint columnName=CLIENT_ID, tableName=CLIENT_SCOPE_CLIENT; addNotNullConstraint columnName=SCOPE_ID, tableName=CLIENT_SCOPE_CLIENT; addPrimaryKey constraintName=C_CLI_SCOPE_BIND, tableName=CLIENT_SCOPE_CLIENT; createIndex indexName=...		\N	3.5.4	\N	\N	1763814917
json-string-accomodation	keycloak	META-INF/jpa-changelog-13.0.0.xml	2021-05-23 09:56:59.49622	96	EXECUTED	7:00e92c604b019717c8db9946ddc85af4	addColumn tableName=REALM_ATTRIBUTE; sql; dropColumn columnName=VALUE, tableName=REALM_ATTRIBUTE; renameColumn newColumnName=VALUE, oldColumnName=VALUE_NEW, tableName=REALM_ATTRIBUTE		\N	3.5.4	\N	\N	1763814917
\.


--
-- Data for Name: databasechangeloglock; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.databasechangeloglock (id, locked, lockgranted, lockedby) FROM stdin;
1	f	\N	\N
1000	f	\N	\N
1001	f	\N	\N
\.


--
-- Data for Name: default_client_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.default_client_scope (realm_id, scope_id, default_scope) FROM stdin;
master	c438bd59-04c6-4baa-92d9-91302d66dafc	f
master	449798f8-bc2f-46c2-b0db-69c71a95191a	t
master	22836b16-7858-4f3b-9ebb-25c6575b27c8	t
master	f02d0379-b1f6-45f0-a0e7-158d4e80c796	t
master	df40a125-8f46-459a-bf16-52cab4495254	f
master	daa21f96-bb34-4129-a50e-e0f97390a05c	f
master	856de14e-e751-4f95-afd5-ad4db6dcbabc	t
master	3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7	t
master	59dd2863-25f0-4b3f-8fd6-dab21e41ba41	f
\.


--
-- Data for Name: event_entity; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.event_entity (id, client_id, details_json, error, ip_address, realm_id, session_id, event_time, type, user_id) FROM stdin;
\.


--
-- Data for Name: fed_user_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_attribute (id, name, user_id, realm_id, storage_provider_id, value) FROM stdin;
\.


--
-- Data for Name: fed_user_consent; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_consent (id, client_id, user_id, realm_id, storage_provider_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: fed_user_consent_cl_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_consent_cl_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: fed_user_credential; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_credential (id, salt, type, created_date, user_id, realm_id, storage_provider_id, user_label, secret_data, credential_data, priority) FROM stdin;
\.


--
-- Data for Name: fed_user_group_membership; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_group_membership (group_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_required_action; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_required_action (required_action, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: fed_user_role_mapping; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.fed_user_role_mapping (role_id, user_id, realm_id, storage_provider_id) FROM stdin;
\.


--
-- Data for Name: federated_identity; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.federated_identity (identity_provider, realm_id, federated_user_id, federated_username, token, user_id) FROM stdin;
\.


--
-- Data for Name: federated_user; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.federated_user (id, storage_provider_id, realm_id) FROM stdin;
\.


--
-- Data for Name: group_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.group_attribute (id, name, value, group_id) FROM stdin;
\.


--
-- Data for Name: group_role_mapping; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.group_role_mapping (role_id, group_id) FROM stdin;
\.


--
-- Data for Name: identity_provider; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.identity_provider (internal_id, enabled, provider_alias, provider_id, store_token, authenticate_by_default, realm_id, add_token_role, trust_email, first_broker_login_flow_id, post_broker_login_flow_id, provider_display_name, link_only) FROM stdin;
\.


--
-- Data for Name: identity_provider_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.identity_provider_config (identity_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: identity_provider_mapper; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.identity_provider_mapper (id, name, idp_alias, idp_mapper_name, realm_id) FROM stdin;
\.


--
-- Data for Name: idp_mapper_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.idp_mapper_config (idp_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: keycloak_group; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.keycloak_group (id, name, parent_group, realm_id) FROM stdin;
\.


--
-- Data for Name: keycloak_role; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.keycloak_role (id, client_realm_constraint, client_role, description, name, realm_id, client, realm) FROM stdin;
3d5c281f-5f5f-456b-9b69-4ffb578d5c91	master	f	${role_default-roles}	default-roles-master	master	\N	\N
2872d781-3448-4ce1-afba-a83a00fc0cd5	master	f	${role_admin}	admin	master	\N	\N
780603d9-200c-45ee-b9ab-a43b14385214	master	f	${role_create-realm}	create-realm	master	\N	\N
d6021cc3-f4a6-4367-b0e3-e94ebb786ffc	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_create-client}	create-client	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
3415bc40-a0da-419c-b8c6-03521e2b98f9	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_view-realm}	view-realm	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
593f5b03-7659-44bc-a4fb-72f2190f715e	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_view-users}	view-users	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
9676e5ab-22b8-4d2e-a3ab-1da3556f18f4	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_view-clients}	view-clients	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
ebe53840-ab98-4e8c-8b4e-3a2be556a5ae	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_view-events}	view-events	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
a90916d3-975e-4dd6-a35d-f19006a1869b	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_view-identity-providers}	view-identity-providers	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
6a1caa1d-48b8-4f0d-a0c6-2003cdf5b00d	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_view-authorization}	view-authorization	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
479b36c2-e836-4a8d-a03c-d71731f5d3ae	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_manage-realm}	manage-realm	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
ac8233ef-d787-4eff-8755-65572fc74e14	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_manage-users}	manage-users	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
8627ef1b-e95a-4606-be62-8657789d7b11	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_manage-clients}	manage-clients	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
a7da3cf3-b3e8-4fd6-868b-9d316730e598	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_manage-events}	manage-events	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
a51a45bf-a3b9-49d8-b465-066bec8d1f78	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_manage-identity-providers}	manage-identity-providers	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
9ff4e995-2a8f-4a0b-8b80-f1a3d44cf065	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_manage-authorization}	manage-authorization	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
c518dc6a-a190-42bc-b489-4e8db59cd57b	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_query-users}	query-users	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
3b4a8722-fd93-43ca-bbd2-7a15e6d36f06	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_query-clients}	query-clients	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
c3afd515-9f7d-4046-8fa8-3c4fe8e5c980	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_query-realms}	query-realms	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
38764b3c-0d72-4b38-be85-7471fa8431ce	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_query-groups}	query-groups	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
ba071797-6bbe-4f25-86ad-52ed09ac301f	4c399d41-a384-46c8-9304-c6de80835fce	t	${role_view-profile}	view-profile	master	4c399d41-a384-46c8-9304-c6de80835fce	\N
38c5d434-0cfd-4a31-8eec-f4d33605e7d1	4c399d41-a384-46c8-9304-c6de80835fce	t	${role_manage-account}	manage-account	master	4c399d41-a384-46c8-9304-c6de80835fce	\N
eee694ed-0136-463d-9bfa-bc0d23170d8c	4c399d41-a384-46c8-9304-c6de80835fce	t	${role_manage-account-links}	manage-account-links	master	4c399d41-a384-46c8-9304-c6de80835fce	\N
fa855e50-2bdf-4d8b-a363-d8def2c434ba	4c399d41-a384-46c8-9304-c6de80835fce	t	${role_view-applications}	view-applications	master	4c399d41-a384-46c8-9304-c6de80835fce	\N
ab84fd83-b82f-4bbe-85dc-16b03ab08c48	4c399d41-a384-46c8-9304-c6de80835fce	t	${role_view-consent}	view-consent	master	4c399d41-a384-46c8-9304-c6de80835fce	\N
42637728-cf1c-4b3f-b7a2-274583911162	4c399d41-a384-46c8-9304-c6de80835fce	t	${role_manage-consent}	manage-consent	master	4c399d41-a384-46c8-9304-c6de80835fce	\N
41833b3b-f019-4350-a4ba-6ab23e8c4b32	4c399d41-a384-46c8-9304-c6de80835fce	t	${role_delete-account}	delete-account	master	4c399d41-a384-46c8-9304-c6de80835fce	\N
30616e8e-1b88-4e26-ae8c-d4bb04e7d43b	9c3361c5-b2cf-44a6-8af7-ca12a481fe79	t	${role_read-token}	read-token	master	9c3361c5-b2cf-44a6-8af7-ca12a481fe79	\N
9d630250-43be-4a83-b257-cabacccf755d	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	t	${role_impersonation}	impersonation	master	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	\N
7dfc5846-32ce-4618-a35f-f790987a452b	master	f	${role_offline-access}	offline_access	master	\N	\N
a44f3d84-0076-4dad-bd84-39daa14d4a67	master	f	${role_uma_authorization}	uma_authorization	master	\N	\N
\.


--
-- Data for Name: migration_model; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.migration_model (id, version, update_time) FROM stdin;
o2tti	13.0.0	1621763824
\.


--
-- Data for Name: offline_client_session; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.offline_client_session (user_session_id, client_id, offline_flag, "timestamp", data, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: offline_user_session; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.offline_user_session (user_session_id, user_id, realm_id, created_on, offline_flag, data, last_session_refresh) FROM stdin;
\.


--
-- Data for Name: policy_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.policy_config (policy_id, name, value) FROM stdin;
\.


--
-- Data for Name: protocol_mapper; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.protocol_mapper (id, name, protocol, protocol_mapper_name, client_id, client_scope_id) FROM stdin;
6d3aa6ef-50c2-4342-bcff-6e0628576e7b	audience resolve	openid-connect	oidc-audience-resolve-mapper	04148fd2-01ed-4d18-b014-b6f6fb57c94b	\N
2c051a49-ddc4-45ac-a5fc-8b6a8eecbdf5	locale	openid-connect	oidc-usermodel-attribute-mapper	2f459e08-5b14-48b6-a51b-6f655329f5b7	\N
4c9c2598-5b05-4eb9-b6ee-ed89fa4b01dc	role list	saml	saml-role-list-mapper	\N	449798f8-bc2f-46c2-b0db-69c71a95191a
d567a3af-0b78-4e50-aeb9-1831866e42ef	full name	openid-connect	oidc-full-name-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
e9f5cc73-09c8-42ae-a149-a490343c9cf8	family name	openid-connect	oidc-usermodel-property-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
4ee3bda4-840b-4797-9576-43555878dc59	given name	openid-connect	oidc-usermodel-property-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
d599bf74-04b7-4b3f-9cd8-e45b48f5e7fd	middle name	openid-connect	oidc-usermodel-attribute-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
e78b7e38-0848-4b9e-bbfe-87c281132668	nickname	openid-connect	oidc-usermodel-attribute-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
07078901-e586-4d47-9f97-817dd4a52b47	username	openid-connect	oidc-usermodel-property-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
0be31505-89c6-4699-aac8-ed33d30cd767	profile	openid-connect	oidc-usermodel-attribute-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
c7339b49-2869-4ae5-97eb-11d194cef527	picture	openid-connect	oidc-usermodel-attribute-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
7e2dd9c0-b02a-418c-9b9c-4779e998d8c1	website	openid-connect	oidc-usermodel-attribute-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
ff385f98-497d-4671-8577-13a8e3f3f436	gender	openid-connect	oidc-usermodel-attribute-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
cf8c755f-d78f-41f9-9261-0abfb0e2da4f	birthdate	openid-connect	oidc-usermodel-attribute-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
c62a6eed-6fea-410e-b984-2e921bcfff41	zoneinfo	openid-connect	oidc-usermodel-attribute-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
fc0d43b8-f062-41e6-8386-d708379a8cee	locale	openid-connect	oidc-usermodel-attribute-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
1a8a835e-6a47-476a-9a18-c5040c932f9e	updated at	openid-connect	oidc-usermodel-attribute-mapper	\N	22836b16-7858-4f3b-9ebb-25c6575b27c8
627dc0b9-d039-4a15-9f11-dcc5622739b8	email	openid-connect	oidc-usermodel-property-mapper	\N	f02d0379-b1f6-45f0-a0e7-158d4e80c796
a668cbf7-71dd-493e-a299-250ba096a0d2	email verified	openid-connect	oidc-usermodel-property-mapper	\N	f02d0379-b1f6-45f0-a0e7-158d4e80c796
ae8a3fb1-2fbc-4167-8a0a-e8db5e6fa595	address	openid-connect	oidc-address-mapper	\N	df40a125-8f46-459a-bf16-52cab4495254
85c13323-c507-4785-97f9-edef1e1b4c79	phone number	openid-connect	oidc-usermodel-attribute-mapper	\N	daa21f96-bb34-4129-a50e-e0f97390a05c
3c683bc4-22dd-4201-8fd8-107d6678cb58	phone number verified	openid-connect	oidc-usermodel-attribute-mapper	\N	daa21f96-bb34-4129-a50e-e0f97390a05c
5d98e238-253e-493c-8b4b-1515db91a5c6	realm roles	openid-connect	oidc-usermodel-realm-role-mapper	\N	856de14e-e751-4f95-afd5-ad4db6dcbabc
6244a220-e168-4d12-a0c8-516c9013f504	client roles	openid-connect	oidc-usermodel-client-role-mapper	\N	856de14e-e751-4f95-afd5-ad4db6dcbabc
16b5b89a-ec92-422f-b017-74d4154e70c5	audience resolve	openid-connect	oidc-audience-resolve-mapper	\N	856de14e-e751-4f95-afd5-ad4db6dcbabc
38951c89-8fe2-4742-94c5-d4ce171bf4b6	allowed web origins	openid-connect	oidc-allowed-origins-mapper	\N	3c27f9c4-da6c-4b1a-8c07-b9cc7a61c4d7
d7019173-6111-4e0a-80c1-8277af60249c	upn	openid-connect	oidc-usermodel-property-mapper	\N	59dd2863-25f0-4b3f-8fd6-dab21e41ba41
957b4160-3e00-42a3-b771-cf6ee043f191	groups	openid-connect	oidc-usermodel-realm-role-mapper	\N	59dd2863-25f0-4b3f-8fd6-dab21e41ba41
\.


--
-- Data for Name: protocol_mapper_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.protocol_mapper_config (protocol_mapper_id, value, name) FROM stdin;
2c051a49-ddc4-45ac-a5fc-8b6a8eecbdf5	true	userinfo.token.claim
2c051a49-ddc4-45ac-a5fc-8b6a8eecbdf5	locale	user.attribute
2c051a49-ddc4-45ac-a5fc-8b6a8eecbdf5	true	id.token.claim
2c051a49-ddc4-45ac-a5fc-8b6a8eecbdf5	true	access.token.claim
2c051a49-ddc4-45ac-a5fc-8b6a8eecbdf5	locale	claim.name
2c051a49-ddc4-45ac-a5fc-8b6a8eecbdf5	String	jsonType.label
4c9c2598-5b05-4eb9-b6ee-ed89fa4b01dc	false	single
4c9c2598-5b05-4eb9-b6ee-ed89fa4b01dc	Basic	attribute.nameformat
4c9c2598-5b05-4eb9-b6ee-ed89fa4b01dc	Role	attribute.name
d567a3af-0b78-4e50-aeb9-1831866e42ef	true	userinfo.token.claim
d567a3af-0b78-4e50-aeb9-1831866e42ef	true	id.token.claim
d567a3af-0b78-4e50-aeb9-1831866e42ef	true	access.token.claim
e9f5cc73-09c8-42ae-a149-a490343c9cf8	true	userinfo.token.claim
e9f5cc73-09c8-42ae-a149-a490343c9cf8	lastName	user.attribute
e9f5cc73-09c8-42ae-a149-a490343c9cf8	true	id.token.claim
e9f5cc73-09c8-42ae-a149-a490343c9cf8	true	access.token.claim
e9f5cc73-09c8-42ae-a149-a490343c9cf8	family_name	claim.name
e9f5cc73-09c8-42ae-a149-a490343c9cf8	String	jsonType.label
4ee3bda4-840b-4797-9576-43555878dc59	true	userinfo.token.claim
4ee3bda4-840b-4797-9576-43555878dc59	firstName	user.attribute
4ee3bda4-840b-4797-9576-43555878dc59	true	id.token.claim
4ee3bda4-840b-4797-9576-43555878dc59	true	access.token.claim
4ee3bda4-840b-4797-9576-43555878dc59	given_name	claim.name
4ee3bda4-840b-4797-9576-43555878dc59	String	jsonType.label
d599bf74-04b7-4b3f-9cd8-e45b48f5e7fd	true	userinfo.token.claim
d599bf74-04b7-4b3f-9cd8-e45b48f5e7fd	middleName	user.attribute
d599bf74-04b7-4b3f-9cd8-e45b48f5e7fd	true	id.token.claim
d599bf74-04b7-4b3f-9cd8-e45b48f5e7fd	true	access.token.claim
d599bf74-04b7-4b3f-9cd8-e45b48f5e7fd	middle_name	claim.name
d599bf74-04b7-4b3f-9cd8-e45b48f5e7fd	String	jsonType.label
e78b7e38-0848-4b9e-bbfe-87c281132668	true	userinfo.token.claim
e78b7e38-0848-4b9e-bbfe-87c281132668	nickname	user.attribute
e78b7e38-0848-4b9e-bbfe-87c281132668	true	id.token.claim
e78b7e38-0848-4b9e-bbfe-87c281132668	true	access.token.claim
e78b7e38-0848-4b9e-bbfe-87c281132668	nickname	claim.name
e78b7e38-0848-4b9e-bbfe-87c281132668	String	jsonType.label
07078901-e586-4d47-9f97-817dd4a52b47	true	userinfo.token.claim
07078901-e586-4d47-9f97-817dd4a52b47	username	user.attribute
07078901-e586-4d47-9f97-817dd4a52b47	true	id.token.claim
07078901-e586-4d47-9f97-817dd4a52b47	true	access.token.claim
07078901-e586-4d47-9f97-817dd4a52b47	preferred_username	claim.name
07078901-e586-4d47-9f97-817dd4a52b47	String	jsonType.label
0be31505-89c6-4699-aac8-ed33d30cd767	true	userinfo.token.claim
0be31505-89c6-4699-aac8-ed33d30cd767	profile	user.attribute
0be31505-89c6-4699-aac8-ed33d30cd767	true	id.token.claim
0be31505-89c6-4699-aac8-ed33d30cd767	true	access.token.claim
0be31505-89c6-4699-aac8-ed33d30cd767	profile	claim.name
0be31505-89c6-4699-aac8-ed33d30cd767	String	jsonType.label
c7339b49-2869-4ae5-97eb-11d194cef527	true	userinfo.token.claim
c7339b49-2869-4ae5-97eb-11d194cef527	picture	user.attribute
c7339b49-2869-4ae5-97eb-11d194cef527	true	id.token.claim
c7339b49-2869-4ae5-97eb-11d194cef527	true	access.token.claim
c7339b49-2869-4ae5-97eb-11d194cef527	picture	claim.name
c7339b49-2869-4ae5-97eb-11d194cef527	String	jsonType.label
7e2dd9c0-b02a-418c-9b9c-4779e998d8c1	true	userinfo.token.claim
7e2dd9c0-b02a-418c-9b9c-4779e998d8c1	website	user.attribute
7e2dd9c0-b02a-418c-9b9c-4779e998d8c1	true	id.token.claim
7e2dd9c0-b02a-418c-9b9c-4779e998d8c1	true	access.token.claim
7e2dd9c0-b02a-418c-9b9c-4779e998d8c1	website	claim.name
7e2dd9c0-b02a-418c-9b9c-4779e998d8c1	String	jsonType.label
ff385f98-497d-4671-8577-13a8e3f3f436	true	userinfo.token.claim
ff385f98-497d-4671-8577-13a8e3f3f436	gender	user.attribute
ff385f98-497d-4671-8577-13a8e3f3f436	true	id.token.claim
ff385f98-497d-4671-8577-13a8e3f3f436	true	access.token.claim
ff385f98-497d-4671-8577-13a8e3f3f436	gender	claim.name
ff385f98-497d-4671-8577-13a8e3f3f436	String	jsonType.label
cf8c755f-d78f-41f9-9261-0abfb0e2da4f	true	userinfo.token.claim
cf8c755f-d78f-41f9-9261-0abfb0e2da4f	birthdate	user.attribute
cf8c755f-d78f-41f9-9261-0abfb0e2da4f	true	id.token.claim
cf8c755f-d78f-41f9-9261-0abfb0e2da4f	true	access.token.claim
cf8c755f-d78f-41f9-9261-0abfb0e2da4f	birthdate	claim.name
cf8c755f-d78f-41f9-9261-0abfb0e2da4f	String	jsonType.label
c62a6eed-6fea-410e-b984-2e921bcfff41	true	userinfo.token.claim
c62a6eed-6fea-410e-b984-2e921bcfff41	zoneinfo	user.attribute
c62a6eed-6fea-410e-b984-2e921bcfff41	true	id.token.claim
c62a6eed-6fea-410e-b984-2e921bcfff41	true	access.token.claim
c62a6eed-6fea-410e-b984-2e921bcfff41	zoneinfo	claim.name
c62a6eed-6fea-410e-b984-2e921bcfff41	String	jsonType.label
fc0d43b8-f062-41e6-8386-d708379a8cee	true	userinfo.token.claim
fc0d43b8-f062-41e6-8386-d708379a8cee	locale	user.attribute
fc0d43b8-f062-41e6-8386-d708379a8cee	true	id.token.claim
fc0d43b8-f062-41e6-8386-d708379a8cee	true	access.token.claim
fc0d43b8-f062-41e6-8386-d708379a8cee	locale	claim.name
fc0d43b8-f062-41e6-8386-d708379a8cee	String	jsonType.label
1a8a835e-6a47-476a-9a18-c5040c932f9e	true	userinfo.token.claim
1a8a835e-6a47-476a-9a18-c5040c932f9e	updatedAt	user.attribute
1a8a835e-6a47-476a-9a18-c5040c932f9e	true	id.token.claim
1a8a835e-6a47-476a-9a18-c5040c932f9e	true	access.token.claim
1a8a835e-6a47-476a-9a18-c5040c932f9e	updated_at	claim.name
1a8a835e-6a47-476a-9a18-c5040c932f9e	String	jsonType.label
627dc0b9-d039-4a15-9f11-dcc5622739b8	true	userinfo.token.claim
627dc0b9-d039-4a15-9f11-dcc5622739b8	email	user.attribute
627dc0b9-d039-4a15-9f11-dcc5622739b8	true	id.token.claim
627dc0b9-d039-4a15-9f11-dcc5622739b8	true	access.token.claim
627dc0b9-d039-4a15-9f11-dcc5622739b8	email	claim.name
627dc0b9-d039-4a15-9f11-dcc5622739b8	String	jsonType.label
a668cbf7-71dd-493e-a299-250ba096a0d2	true	userinfo.token.claim
a668cbf7-71dd-493e-a299-250ba096a0d2	emailVerified	user.attribute
a668cbf7-71dd-493e-a299-250ba096a0d2	true	id.token.claim
a668cbf7-71dd-493e-a299-250ba096a0d2	true	access.token.claim
a668cbf7-71dd-493e-a299-250ba096a0d2	email_verified	claim.name
a668cbf7-71dd-493e-a299-250ba096a0d2	boolean	jsonType.label
ae8a3fb1-2fbc-4167-8a0a-e8db5e6fa595	formatted	user.attribute.formatted
ae8a3fb1-2fbc-4167-8a0a-e8db5e6fa595	country	user.attribute.country
ae8a3fb1-2fbc-4167-8a0a-e8db5e6fa595	postal_code	user.attribute.postal_code
ae8a3fb1-2fbc-4167-8a0a-e8db5e6fa595	true	userinfo.token.claim
ae8a3fb1-2fbc-4167-8a0a-e8db5e6fa595	street	user.attribute.street
ae8a3fb1-2fbc-4167-8a0a-e8db5e6fa595	true	id.token.claim
ae8a3fb1-2fbc-4167-8a0a-e8db5e6fa595	region	user.attribute.region
ae8a3fb1-2fbc-4167-8a0a-e8db5e6fa595	true	access.token.claim
ae8a3fb1-2fbc-4167-8a0a-e8db5e6fa595	locality	user.attribute.locality
85c13323-c507-4785-97f9-edef1e1b4c79	true	userinfo.token.claim
85c13323-c507-4785-97f9-edef1e1b4c79	phoneNumber	user.attribute
85c13323-c507-4785-97f9-edef1e1b4c79	true	id.token.claim
85c13323-c507-4785-97f9-edef1e1b4c79	true	access.token.claim
85c13323-c507-4785-97f9-edef1e1b4c79	phone_number	claim.name
85c13323-c507-4785-97f9-edef1e1b4c79	String	jsonType.label
3c683bc4-22dd-4201-8fd8-107d6678cb58	true	userinfo.token.claim
3c683bc4-22dd-4201-8fd8-107d6678cb58	phoneNumberVerified	user.attribute
3c683bc4-22dd-4201-8fd8-107d6678cb58	true	id.token.claim
3c683bc4-22dd-4201-8fd8-107d6678cb58	true	access.token.claim
3c683bc4-22dd-4201-8fd8-107d6678cb58	phone_number_verified	claim.name
3c683bc4-22dd-4201-8fd8-107d6678cb58	boolean	jsonType.label
5d98e238-253e-493c-8b4b-1515db91a5c6	true	multivalued
5d98e238-253e-493c-8b4b-1515db91a5c6	foo	user.attribute
5d98e238-253e-493c-8b4b-1515db91a5c6	true	access.token.claim
5d98e238-253e-493c-8b4b-1515db91a5c6	realm_access.roles	claim.name
5d98e238-253e-493c-8b4b-1515db91a5c6	String	jsonType.label
6244a220-e168-4d12-a0c8-516c9013f504	true	multivalued
6244a220-e168-4d12-a0c8-516c9013f504	foo	user.attribute
6244a220-e168-4d12-a0c8-516c9013f504	true	access.token.claim
6244a220-e168-4d12-a0c8-516c9013f504	resource_access.${client_id}.roles	claim.name
6244a220-e168-4d12-a0c8-516c9013f504	String	jsonType.label
d7019173-6111-4e0a-80c1-8277af60249c	true	userinfo.token.claim
d7019173-6111-4e0a-80c1-8277af60249c	username	user.attribute
d7019173-6111-4e0a-80c1-8277af60249c	true	id.token.claim
d7019173-6111-4e0a-80c1-8277af60249c	true	access.token.claim
d7019173-6111-4e0a-80c1-8277af60249c	upn	claim.name
d7019173-6111-4e0a-80c1-8277af60249c	String	jsonType.label
957b4160-3e00-42a3-b771-cf6ee043f191	true	multivalued
957b4160-3e00-42a3-b771-cf6ee043f191	foo	user.attribute
957b4160-3e00-42a3-b771-cf6ee043f191	true	id.token.claim
957b4160-3e00-42a3-b771-cf6ee043f191	true	access.token.claim
957b4160-3e00-42a3-b771-cf6ee043f191	groups	claim.name
957b4160-3e00-42a3-b771-cf6ee043f191	String	jsonType.label
\.


--
-- Data for Name: realm; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm (id, access_code_lifespan, user_action_lifespan, access_token_lifespan, account_theme, admin_theme, email_theme, enabled, events_enabled, events_expiration, login_theme, name, not_before, password_policy, registration_allowed, remember_me, reset_password_allowed, social, ssl_required, sso_idle_timeout, sso_max_lifespan, update_profile_on_soc_login, verify_email, master_admin_client, login_lifespan, internationalization_enabled, default_locale, reg_email_as_username, admin_events_enabled, admin_events_details_enabled, edit_username_allowed, otp_policy_counter, otp_policy_window, otp_policy_period, otp_policy_digits, otp_policy_alg, otp_policy_type, browser_flow, registration_flow, direct_grant_flow, reset_credentials_flow, client_auth_flow, offline_session_idle_timeout, revoke_refresh_token, access_token_life_implicit, login_with_email_allowed, duplicate_emails_allowed, docker_auth_flow, refresh_token_max_reuse, allow_user_managed_access, sso_max_lifespan_remember_me, sso_idle_timeout_remember_me, default_role) FROM stdin;
master	60	300	60	\N	\N	\N	t	f	0	\N	master	0	\N	f	f	f	f	EXTERNAL	1800	36000	f	f	ce7c7738-b3f6-439c-8371-856bfb8ec2f9	1800	f	\N	f	f	f	f	0	1	30	6	HmacSHA1	totp	5ff407a3-4bdf-4435-ad60-d6f9b0862bda	a0a4dab1-3776-48db-b6d0-abe6ee66e961	2db09a0a-261a-4fbd-bfea-1370dcc82f7f	7b3d04fe-c23b-4dd8-a020-8b93f58dbc9b	374bf462-485b-4a3b-9eb2-1c3589356db0	2592000	f	900	t	f	9d13d43a-263d-497d-a91a-eaa08752d402	0	f	0	0	3d5c281f-5f5f-456b-9b69-4ffb578d5c91
\.


--
-- Data for Name: realm_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_attribute (name, realm_id, value) FROM stdin;
_browser_header.contentSecurityPolicyReportOnly	master	
_browser_header.xContentTypeOptions	master	nosniff
_browser_header.xRobotsTag	master	none
_browser_header.xFrameOptions	master	SAMEORIGIN
_browser_header.contentSecurityPolicy	master	frame-src 'self'; frame-ancestors 'self'; object-src 'none';
_browser_header.xXSSProtection	master	1; mode=block
_browser_header.strictTransportSecurity	master	max-age=31536000; includeSubDomains
bruteForceProtected	master	false
permanentLockout	master	false
maxFailureWaitSeconds	master	900
minimumQuickLoginWaitSeconds	master	60
waitIncrementSeconds	master	60
quickLoginCheckMilliSeconds	master	1000
maxDeltaTimeSeconds	master	43200
failureFactor	master	30
client-policies.profiles	master	{"profiles":[{"name":"builtin-default-profile","description":"The built-in default profile for enforcing basic security level to clients.","builtin":true,"executors":[{"secure-session-enforce-executor":{}}]}]}
client-policies.policies	master	{"policies":[{"name":"builtin-default-policy","description":"The built-in default policy applied to all clients.","builtin":true,"enable":false,"conditions":[{"anyclient-condition":{}}],"profiles":["builtin-default-profile"]}]}
displayName	master	Keycloak
displayNameHtml	master	<div class="kc-logo-text"><span>Keycloak</span></div>
defaultSignatureAlgorithm	master	RS256
offlineSessionMaxLifespanEnabled	master	false
offlineSessionMaxLifespan	master	5184000
\.


--
-- Data for Name: realm_default_groups; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_default_groups (realm_id, group_id) FROM stdin;
\.


--
-- Data for Name: realm_enabled_event_types; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_enabled_event_types (realm_id, value) FROM stdin;
\.


--
-- Data for Name: realm_events_listeners; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_events_listeners (realm_id, value) FROM stdin;
master	jboss-logging
\.


--
-- Data for Name: realm_localizations; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_localizations (realm_id, locale, texts) FROM stdin;
\.


--
-- Data for Name: realm_required_credential; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_required_credential (type, form_label, input, secret, realm_id) FROM stdin;
password	password	t	t	master
\.


--
-- Data for Name: realm_smtp_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_smtp_config (realm_id, value, name) FROM stdin;
\.


--
-- Data for Name: realm_supported_locales; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.realm_supported_locales (realm_id, value) FROM stdin;
\.


--
-- Data for Name: redirect_uris; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.redirect_uris (client_id, value) FROM stdin;
4c399d41-a384-46c8-9304-c6de80835fce	/realms/master/account/*
04148fd2-01ed-4d18-b014-b6f6fb57c94b	/realms/master/account/*
2f459e08-5b14-48b6-a51b-6f655329f5b7	/admin/master/console/*
\.


--
-- Data for Name: required_action_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.required_action_config (required_action_id, value, name) FROM stdin;
\.


--
-- Data for Name: required_action_provider; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.required_action_provider (id, alias, name, realm_id, enabled, default_action, provider_id, priority) FROM stdin;
8aa587b3-2143-4c43-a1a0-baed4d6b0baf	VERIFY_EMAIL	Verify Email	master	t	f	VERIFY_EMAIL	50
1072eddd-c8b8-4cb5-9c20-ee7c3ea4e85d	UPDATE_PROFILE	Update Profile	master	t	f	UPDATE_PROFILE	40
0dc6baf3-61b2-46dc-bba2-f143e7a2174e	CONFIGURE_TOTP	Configure OTP	master	t	f	CONFIGURE_TOTP	10
a3b0a5fb-c93d-46b2-8338-185b23d1ae1d	UPDATE_PASSWORD	Update Password	master	t	f	UPDATE_PASSWORD	30
45e1dbc2-8635-46c9-a56d-168339311291	terms_and_conditions	Terms and Conditions	master	f	f	terms_and_conditions	20
a0f9a6b8-5dfb-4c91-93c0-d1dc1d8bc0f0	update_user_locale	Update User Locale	master	t	f	update_user_locale	1000
5468b941-68d7-4105-ad18-ed041336443c	delete_account	Delete Account	master	f	f	delete_account	60
\.


--
-- Data for Name: resource_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_attribute (id, name, value, resource_id) FROM stdin;
\.


--
-- Data for Name: resource_policy; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_policy (resource_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_scope (resource_id, scope_id) FROM stdin;
\.


--
-- Data for Name: resource_server; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_server (id, allow_rs_remote_mgmt, policy_enforce_mode, decision_strategy) FROM stdin;
\.


--
-- Data for Name: resource_server_perm_ticket; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_server_perm_ticket (id, owner, requester, created_timestamp, granted_timestamp, resource_id, scope_id, resource_server_id, policy_id) FROM stdin;
\.


--
-- Data for Name: resource_server_policy; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_server_policy (id, name, description, type, decision_strategy, logic, resource_server_id, owner) FROM stdin;
\.


--
-- Data for Name: resource_server_resource; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_server_resource (id, name, type, icon_uri, owner, resource_server_id, owner_managed_access, display_name) FROM stdin;
\.


--
-- Data for Name: resource_server_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_server_scope (id, name, icon_uri, resource_server_id, display_name) FROM stdin;
\.


--
-- Data for Name: resource_uris; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.resource_uris (resource_id, value) FROM stdin;
\.


--
-- Data for Name: role_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.role_attribute (id, role_id, name, value) FROM stdin;
\.


--
-- Data for Name: scope_mapping; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.scope_mapping (client_id, role_id) FROM stdin;
04148fd2-01ed-4d18-b014-b6f6fb57c94b	38c5d434-0cfd-4a31-8eec-f4d33605e7d1
\.


--
-- Data for Name: scope_policy; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.scope_policy (scope_id, policy_id) FROM stdin;
\.


--
-- Data for Name: user_attribute; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_attribute (name, value, user_id, id) FROM stdin;
\.


--
-- Data for Name: user_consent; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_consent (id, client_id, user_id, created_date, last_updated_date, client_storage_provider, external_client_id) FROM stdin;
\.


--
-- Data for Name: user_consent_client_scope; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_consent_client_scope (user_consent_id, scope_id) FROM stdin;
\.


--
-- Data for Name: user_entity; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_entity (id, email, email_constraint, email_verified, enabled, federation_link, first_name, last_name, realm_id, username, created_timestamp, service_account_client_link, not_before) FROM stdin;
9e60a853-0467-432d-af86-25dd3eb2f227	\N	f3b2c956-5609-459b-8e4f-6bd259ad342d	f	t	\N	\N	\N	master	admin	1621763827568	\N	0
\.


--
-- Data for Name: user_federation_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_federation_config (user_federation_provider_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_federation_mapper (id, name, federation_provider_id, federation_mapper_type, realm_id) FROM stdin;
\.


--
-- Data for Name: user_federation_mapper_config; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_federation_mapper_config (user_federation_mapper_id, value, name) FROM stdin;
\.


--
-- Data for Name: user_federation_provider; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_federation_provider (id, changed_sync_period, display_name, full_sync_period, last_sync, priority, provider_name, realm_id) FROM stdin;
\.


--
-- Data for Name: user_group_membership; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_group_membership (group_id, user_id) FROM stdin;
\.


--
-- Data for Name: user_required_action; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_required_action (user_id, required_action) FROM stdin;
\.


--
-- Data for Name: user_role_mapping; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_role_mapping (role_id, user_id) FROM stdin;
3d5c281f-5f5f-456b-9b69-4ffb578d5c91	9e60a853-0467-432d-af86-25dd3eb2f227
2872d781-3448-4ce1-afba-a83a00fc0cd5	9e60a853-0467-432d-af86-25dd3eb2f227
\.


--
-- Data for Name: user_session; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_session (id, auth_method, ip_address, last_session_refresh, login_username, realm_id, remember_me, started, user_id, user_session_state, broker_session_id, broker_user_id) FROM stdin;
\.


--
-- Data for Name: user_session_note; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.user_session_note (user_session, name, value) FROM stdin;
\.


--
-- Data for Name: username_login_failure; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.username_login_failure (realm_id, username, failed_login_not_before, last_failure, last_ip_failure, num_failures) FROM stdin;
\.


--
-- Data for Name: web_origins; Type: TABLE DATA; Schema: public; Owner: dba
--

COPY public.web_origins (client_id, value) FROM stdin;
2f459e08-5b14-48b6-a51b-6f655329f5b7	+
\.


--
-- Name: username_login_failure CONSTRAINT_17-2; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.username_login_failure
    ADD CONSTRAINT "CONSTRAINT_17-2" PRIMARY KEY (realm_id, username);


--
-- Name: keycloak_role UK_J3RWUVD56ONTGSUHOGM184WW2-2; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT "UK_J3RWUVD56ONTGSUHOGM184WW2-2" UNIQUE (name, client_realm_constraint);


--
-- Name: client_auth_flow_bindings c_cli_flow_bind; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_auth_flow_bindings
    ADD CONSTRAINT c_cli_flow_bind PRIMARY KEY (client_id, binding_name);


--
-- Name: client_scope_client c_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_client
    ADD CONSTRAINT c_cli_scope_bind PRIMARY KEY (client_id, scope_id);


--
-- Name: client_initial_access cnstr_client_init_acc_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT cnstr_client_init_acc_pk PRIMARY KEY (id);


--
-- Name: realm_default_groups con_group_id_def_groups; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT con_group_id_def_groups UNIQUE (group_id);


--
-- Name: broker_link constr_broker_link_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.broker_link
    ADD CONSTRAINT constr_broker_link_pk PRIMARY KEY (identity_provider, user_id);


--
-- Name: client_user_session_note constr_cl_usr_ses_note; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT constr_cl_usr_ses_note PRIMARY KEY (client_session, name);


--
-- Name: component_config constr_component_config_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT constr_component_config_pk PRIMARY KEY (id);


--
-- Name: component constr_component_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT constr_component_pk PRIMARY KEY (id);


--
-- Name: fed_user_required_action constr_fed_required_action; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_required_action
    ADD CONSTRAINT constr_fed_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: fed_user_attribute constr_fed_user_attr_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_attribute
    ADD CONSTRAINT constr_fed_user_attr_pk PRIMARY KEY (id);


--
-- Name: fed_user_consent constr_fed_user_consent_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_consent
    ADD CONSTRAINT constr_fed_user_consent_pk PRIMARY KEY (id);


--
-- Name: fed_user_credential constr_fed_user_cred_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_credential
    ADD CONSTRAINT constr_fed_user_cred_pk PRIMARY KEY (id);


--
-- Name: fed_user_group_membership constr_fed_user_group; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_group_membership
    ADD CONSTRAINT constr_fed_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: fed_user_role_mapping constr_fed_user_role; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_role_mapping
    ADD CONSTRAINT constr_fed_user_role PRIMARY KEY (role_id, user_id);


--
-- Name: federated_user constr_federated_user; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.federated_user
    ADD CONSTRAINT constr_federated_user PRIMARY KEY (id);


--
-- Name: realm_default_groups constr_realm_default_groups; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT constr_realm_default_groups PRIMARY KEY (realm_id, group_id);


--
-- Name: realm_enabled_event_types constr_realm_enabl_event_types; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT constr_realm_enabl_event_types PRIMARY KEY (realm_id, value);


--
-- Name: realm_events_listeners constr_realm_events_listeners; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT constr_realm_events_listeners PRIMARY KEY (realm_id, value);


--
-- Name: realm_supported_locales constr_realm_supported_locales; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT constr_realm_supported_locales PRIMARY KEY (realm_id, value);


--
-- Name: identity_provider constraint_2b; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT constraint_2b PRIMARY KEY (internal_id);


--
-- Name: client_attributes constraint_3c; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT constraint_3c PRIMARY KEY (client_id, name);


--
-- Name: event_entity constraint_4; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.event_entity
    ADD CONSTRAINT constraint_4 PRIMARY KEY (id);


--
-- Name: federated_identity constraint_40; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT constraint_40 PRIMARY KEY (identity_provider, user_id);


--
-- Name: realm constraint_4a; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT constraint_4a PRIMARY KEY (id);


--
-- Name: client_session_role constraint_5; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT constraint_5 PRIMARY KEY (client_session, role_id);


--
-- Name: user_session constraint_57; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_session
    ADD CONSTRAINT constraint_57 PRIMARY KEY (id);


--
-- Name: user_federation_provider constraint_5c; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT constraint_5c PRIMARY KEY (id);


--
-- Name: client_session_note constraint_5e; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT constraint_5e PRIMARY KEY (client_session, name);


--
-- Name: client constraint_7; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT constraint_7 PRIMARY KEY (id);


--
-- Name: client_session constraint_8; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT constraint_8 PRIMARY KEY (id);


--
-- Name: scope_mapping constraint_81; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT constraint_81 PRIMARY KEY (client_id, role_id);


--
-- Name: client_node_registrations constraint_84; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT constraint_84 PRIMARY KEY (client_id, name);


--
-- Name: realm_attribute constraint_9; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT constraint_9 PRIMARY KEY (name, realm_id);


--
-- Name: realm_required_credential constraint_92; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT constraint_92 PRIMARY KEY (realm_id, type);


--
-- Name: keycloak_role constraint_a; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT constraint_a PRIMARY KEY (id);


--
-- Name: admin_event_entity constraint_admin_event_entity; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.admin_event_entity
    ADD CONSTRAINT constraint_admin_event_entity PRIMARY KEY (id);


--
-- Name: authenticator_config_entry constraint_auth_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authenticator_config_entry
    ADD CONSTRAINT constraint_auth_cfg_pk PRIMARY KEY (authenticator_id, name);


--
-- Name: authentication_execution constraint_auth_exec_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT constraint_auth_exec_pk PRIMARY KEY (id);


--
-- Name: authentication_flow constraint_auth_flow_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT constraint_auth_flow_pk PRIMARY KEY (id);


--
-- Name: authenticator_config constraint_auth_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT constraint_auth_pk PRIMARY KEY (id);


--
-- Name: client_session_auth_status constraint_auth_status_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT constraint_auth_status_pk PRIMARY KEY (client_session, authenticator);


--
-- Name: user_role_mapping constraint_c; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT constraint_c PRIMARY KEY (role_id, user_id);


--
-- Name: composite_role constraint_composite_role; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT constraint_composite_role PRIMARY KEY (composite, child_role);


--
-- Name: client_session_prot_mapper constraint_cs_pmp_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT constraint_cs_pmp_pk PRIMARY KEY (client_session, protocol_mapper_id);


--
-- Name: identity_provider_config constraint_d; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT constraint_d PRIMARY KEY (identity_provider_id, name);


--
-- Name: policy_config constraint_dpc; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT constraint_dpc PRIMARY KEY (policy_id, name);


--
-- Name: realm_smtp_config constraint_e; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT constraint_e PRIMARY KEY (realm_id, name);


--
-- Name: credential constraint_f; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT constraint_f PRIMARY KEY (id);


--
-- Name: user_federation_config constraint_f9; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT constraint_f9 PRIMARY KEY (user_federation_provider_id, name);


--
-- Name: resource_server_perm_ticket constraint_fapmt; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT constraint_fapmt PRIMARY KEY (id);


--
-- Name: resource_server_resource constraint_farsr; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT constraint_farsr PRIMARY KEY (id);


--
-- Name: resource_server_policy constraint_farsrp; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT constraint_farsrp PRIMARY KEY (id);


--
-- Name: associated_policy constraint_farsrpap; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT constraint_farsrpap PRIMARY KEY (policy_id, associated_policy_id);


--
-- Name: resource_policy constraint_farsrpp; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT constraint_farsrpp PRIMARY KEY (resource_id, policy_id);


--
-- Name: resource_server_scope constraint_farsrs; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT constraint_farsrs PRIMARY KEY (id);


--
-- Name: resource_scope constraint_farsrsp; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT constraint_farsrsp PRIMARY KEY (resource_id, scope_id);


--
-- Name: scope_policy constraint_farsrsps; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT constraint_farsrsps PRIMARY KEY (scope_id, policy_id);


--
-- Name: user_entity constraint_fb; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT constraint_fb PRIMARY KEY (id);


--
-- Name: user_federation_mapper_config constraint_fedmapper_cfg_pm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT constraint_fedmapper_cfg_pm PRIMARY KEY (user_federation_mapper_id, name);


--
-- Name: user_federation_mapper constraint_fedmapperpm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT constraint_fedmapperpm PRIMARY KEY (id);


--
-- Name: fed_user_consent_cl_scope constraint_fgrntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.fed_user_consent_cl_scope
    ADD CONSTRAINT constraint_fgrntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent_client_scope constraint_grntcsnt_clsc_pm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT constraint_grntcsnt_clsc_pm PRIMARY KEY (user_consent_id, scope_id);


--
-- Name: user_consent constraint_grntcsnt_pm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT constraint_grntcsnt_pm PRIMARY KEY (id);


--
-- Name: keycloak_group constraint_group; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT constraint_group PRIMARY KEY (id);


--
-- Name: group_attribute constraint_group_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT constraint_group_attribute_pk PRIMARY KEY (id);


--
-- Name: group_role_mapping constraint_group_role; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT constraint_group_role PRIMARY KEY (role_id, group_id);


--
-- Name: identity_provider_mapper constraint_idpm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT constraint_idpm PRIMARY KEY (id);


--
-- Name: idp_mapper_config constraint_idpmconfig; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT constraint_idpmconfig PRIMARY KEY (idp_mapper_id, name);


--
-- Name: migration_model constraint_migmod; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.migration_model
    ADD CONSTRAINT constraint_migmod PRIMARY KEY (id);


--
-- Name: offline_client_session constraint_offl_cl_ses_pk3; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.offline_client_session
    ADD CONSTRAINT constraint_offl_cl_ses_pk3 PRIMARY KEY (user_session_id, client_id, client_storage_provider, external_client_id, offline_flag);


--
-- Name: offline_user_session constraint_offl_us_ses_pk2; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.offline_user_session
    ADD CONSTRAINT constraint_offl_us_ses_pk2 PRIMARY KEY (user_session_id, offline_flag);


--
-- Name: protocol_mapper constraint_pcm; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT constraint_pcm PRIMARY KEY (id);


--
-- Name: protocol_mapper_config constraint_pmconfig; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT constraint_pmconfig PRIMARY KEY (protocol_mapper_id, name);


--
-- Name: redirect_uris constraint_redirect_uris; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT constraint_redirect_uris PRIMARY KEY (client_id, value);


--
-- Name: required_action_config constraint_req_act_cfg_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.required_action_config
    ADD CONSTRAINT constraint_req_act_cfg_pk PRIMARY KEY (required_action_id, name);


--
-- Name: required_action_provider constraint_req_act_prv_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT constraint_req_act_prv_pk PRIMARY KEY (id);


--
-- Name: user_required_action constraint_required_action; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT constraint_required_action PRIMARY KEY (required_action, user_id);


--
-- Name: resource_uris constraint_resour_uris_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT constraint_resour_uris_pk PRIMARY KEY (resource_id, value);


--
-- Name: role_attribute constraint_role_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT constraint_role_attribute_pk PRIMARY KEY (id);


--
-- Name: user_attribute constraint_user_attribute_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT constraint_user_attribute_pk PRIMARY KEY (id);


--
-- Name: user_group_membership constraint_user_group; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT constraint_user_group PRIMARY KEY (group_id, user_id);


--
-- Name: user_session_note constraint_usn_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT constraint_usn_pk PRIMARY KEY (user_session, name);


--
-- Name: web_origins constraint_web_origins; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT constraint_web_origins PRIMARY KEY (client_id, value);


--
-- Name: client_scope_attributes pk_cl_tmpl_attr; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT pk_cl_tmpl_attr PRIMARY KEY (scope_id, name);


--
-- Name: client_scope pk_cli_template; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT pk_cli_template PRIMARY KEY (id);


--
-- Name: databasechangeloglock pk_databasechangeloglock; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.databasechangeloglock
    ADD CONSTRAINT pk_databasechangeloglock PRIMARY KEY (id);


--
-- Name: resource_server pk_resource_server; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server
    ADD CONSTRAINT pk_resource_server PRIMARY KEY (id);


--
-- Name: client_scope_role_mapping pk_template_scope; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT pk_template_scope PRIMARY KEY (scope_id, role_id);


--
-- Name: default_client_scope r_def_cli_scope_bind; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT r_def_cli_scope_bind PRIMARY KEY (realm_id, scope_id);


--
-- Name: realm_localizations realm_localizations_pkey; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_localizations
    ADD CONSTRAINT realm_localizations_pkey PRIMARY KEY (realm_id, locale);


--
-- Name: resource_attribute res_attr_pk; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT res_attr_pk PRIMARY KEY (id);


--
-- Name: keycloak_group sibling_names; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.keycloak_group
    ADD CONSTRAINT sibling_names UNIQUE (realm_id, parent_group, name);


--
-- Name: identity_provider uk_2daelwnibji49avxsrtuf6xj33; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT uk_2daelwnibji49avxsrtuf6xj33 UNIQUE (provider_alias, realm_id);


--
-- Name: client uk_b71cjlbenv945rb6gcon438at; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client
    ADD CONSTRAINT uk_b71cjlbenv945rb6gcon438at UNIQUE (realm_id, client_id);


--
-- Name: client_scope uk_cli_scope; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope
    ADD CONSTRAINT uk_cli_scope UNIQUE (realm_id, name);


--
-- Name: user_entity uk_dykn684sl8up1crfei6eckhd7; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_dykn684sl8up1crfei6eckhd7 UNIQUE (realm_id, email_constraint);


--
-- Name: resource_server_resource uk_frsr6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5ha6 UNIQUE (name, owner, resource_server_id);


--
-- Name: resource_server_perm_ticket uk_frsr6t700s9v50bu18ws5pmt; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT uk_frsr6t700s9v50bu18ws5pmt UNIQUE (owner, requester, resource_server_id, resource_id, scope_id);


--
-- Name: resource_server_policy uk_frsrpt700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT uk_frsrpt700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: resource_server_scope uk_frsrst700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT uk_frsrst700s9v50bu18ws5ha6 UNIQUE (name, resource_server_id);


--
-- Name: user_consent uk_jkuwuvd56ontgsuhogm8uewrt; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT uk_jkuwuvd56ontgsuhogm8uewrt UNIQUE (client_id, client_storage_provider, external_client_id, user_id);


--
-- Name: realm uk_orvsdmla56612eaefiq6wl5oi; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm
    ADD CONSTRAINT uk_orvsdmla56612eaefiq6wl5oi UNIQUE (name);


--
-- Name: user_entity uk_ru8tt6t700s9v50bu18ws5ha6; Type: CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_entity
    ADD CONSTRAINT uk_ru8tt6t700s9v50bu18ws5ha6 UNIQUE (realm_id, username);


--
-- Name: idx_assoc_pol_assoc_pol_id; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_assoc_pol_assoc_pol_id ON public.associated_policy USING btree (associated_policy_id);


--
-- Name: idx_auth_config_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_auth_config_realm ON public.authenticator_config USING btree (realm_id);


--
-- Name: idx_auth_exec_flow; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_auth_exec_flow ON public.authentication_execution USING btree (flow_id);


--
-- Name: idx_auth_exec_realm_flow; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_auth_exec_realm_flow ON public.authentication_execution USING btree (realm_id, flow_id);


--
-- Name: idx_auth_flow_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_auth_flow_realm ON public.authentication_flow USING btree (realm_id);


--
-- Name: idx_cl_clscope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_cl_clscope ON public.client_scope_client USING btree (scope_id);


--
-- Name: idx_client_id; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_client_id ON public.client USING btree (client_id);


--
-- Name: idx_client_init_acc_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_client_init_acc_realm ON public.client_initial_access USING btree (realm_id);


--
-- Name: idx_client_session_session; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_client_session_session ON public.client_session USING btree (session_id);


--
-- Name: idx_clscope_attrs; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_clscope_attrs ON public.client_scope_attributes USING btree (scope_id);


--
-- Name: idx_clscope_cl; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_clscope_cl ON public.client_scope_client USING btree (client_id);


--
-- Name: idx_clscope_protmap; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_clscope_protmap ON public.protocol_mapper USING btree (client_scope_id);


--
-- Name: idx_clscope_role; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_clscope_role ON public.client_scope_role_mapping USING btree (scope_id);


--
-- Name: idx_compo_config_compo; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_compo_config_compo ON public.component_config USING btree (component_id);


--
-- Name: idx_component_provider_type; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_component_provider_type ON public.component USING btree (provider_type);


--
-- Name: idx_component_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_component_realm ON public.component USING btree (realm_id);


--
-- Name: idx_composite; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_composite ON public.composite_role USING btree (composite);


--
-- Name: idx_composite_child; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_composite_child ON public.composite_role USING btree (child_role);


--
-- Name: idx_defcls_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_defcls_realm ON public.default_client_scope USING btree (realm_id);


--
-- Name: idx_defcls_scope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_defcls_scope ON public.default_client_scope USING btree (scope_id);


--
-- Name: idx_event_time; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_event_time ON public.event_entity USING btree (realm_id, event_time);


--
-- Name: idx_fedidentity_feduser; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fedidentity_feduser ON public.federated_identity USING btree (federated_user_id);


--
-- Name: idx_fedidentity_user; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fedidentity_user ON public.federated_identity USING btree (user_id);


--
-- Name: idx_fu_attribute; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_attribute ON public.fed_user_attribute USING btree (user_id, realm_id, name);


--
-- Name: idx_fu_cnsnt_ext; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_cnsnt_ext ON public.fed_user_consent USING btree (user_id, client_storage_provider, external_client_id);


--
-- Name: idx_fu_consent; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_consent ON public.fed_user_consent USING btree (user_id, client_id);


--
-- Name: idx_fu_consent_ru; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_consent_ru ON public.fed_user_consent USING btree (realm_id, user_id);


--
-- Name: idx_fu_credential; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_credential ON public.fed_user_credential USING btree (user_id, type);


--
-- Name: idx_fu_credential_ru; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_credential_ru ON public.fed_user_credential USING btree (realm_id, user_id);


--
-- Name: idx_fu_group_membership; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_group_membership ON public.fed_user_group_membership USING btree (user_id, group_id);


--
-- Name: idx_fu_group_membership_ru; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_group_membership_ru ON public.fed_user_group_membership USING btree (realm_id, user_id);


--
-- Name: idx_fu_required_action; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_required_action ON public.fed_user_required_action USING btree (user_id, required_action);


--
-- Name: idx_fu_required_action_ru; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_required_action_ru ON public.fed_user_required_action USING btree (realm_id, user_id);


--
-- Name: idx_fu_role_mapping; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_role_mapping ON public.fed_user_role_mapping USING btree (user_id, role_id);


--
-- Name: idx_fu_role_mapping_ru; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_fu_role_mapping_ru ON public.fed_user_role_mapping USING btree (realm_id, user_id);


--
-- Name: idx_group_attr_group; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_group_attr_group ON public.group_attribute USING btree (group_id);


--
-- Name: idx_group_role_mapp_group; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_group_role_mapp_group ON public.group_role_mapping USING btree (group_id);


--
-- Name: idx_id_prov_mapp_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_id_prov_mapp_realm ON public.identity_provider_mapper USING btree (realm_id);


--
-- Name: idx_ident_prov_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_ident_prov_realm ON public.identity_provider USING btree (realm_id);


--
-- Name: idx_keycloak_role_client; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_keycloak_role_client ON public.keycloak_role USING btree (client);


--
-- Name: idx_keycloak_role_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_keycloak_role_realm ON public.keycloak_role USING btree (realm);


--
-- Name: idx_offline_uss_createdon; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_offline_uss_createdon ON public.offline_user_session USING btree (created_on);


--
-- Name: idx_offline_uss_preload; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_offline_uss_preload ON public.offline_user_session USING btree (offline_flag, created_on, user_session_id);


--
-- Name: idx_protocol_mapper_client; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_protocol_mapper_client ON public.protocol_mapper USING btree (client_id);


--
-- Name: idx_realm_attr_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_attr_realm ON public.realm_attribute USING btree (realm_id);


--
-- Name: idx_realm_clscope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_clscope ON public.client_scope USING btree (realm_id);


--
-- Name: idx_realm_def_grp_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_def_grp_realm ON public.realm_default_groups USING btree (realm_id);


--
-- Name: idx_realm_evt_list_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_evt_list_realm ON public.realm_events_listeners USING btree (realm_id);


--
-- Name: idx_realm_evt_types_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_evt_types_realm ON public.realm_enabled_event_types USING btree (realm_id);


--
-- Name: idx_realm_master_adm_cli; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_master_adm_cli ON public.realm USING btree (master_admin_client);


--
-- Name: idx_realm_supp_local_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_realm_supp_local_realm ON public.realm_supported_locales USING btree (realm_id);


--
-- Name: idx_redir_uri_client; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_redir_uri_client ON public.redirect_uris USING btree (client_id);


--
-- Name: idx_req_act_prov_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_req_act_prov_realm ON public.required_action_provider USING btree (realm_id);


--
-- Name: idx_res_policy_policy; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_res_policy_policy ON public.resource_policy USING btree (policy_id);


--
-- Name: idx_res_scope_scope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_res_scope_scope ON public.resource_scope USING btree (scope_id);


--
-- Name: idx_res_serv_pol_res_serv; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_res_serv_pol_res_serv ON public.resource_server_policy USING btree (resource_server_id);


--
-- Name: idx_res_srv_res_res_srv; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_res_srv_res_res_srv ON public.resource_server_resource USING btree (resource_server_id);


--
-- Name: idx_res_srv_scope_res_srv; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_res_srv_scope_res_srv ON public.resource_server_scope USING btree (resource_server_id);


--
-- Name: idx_role_attribute; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_role_attribute ON public.role_attribute USING btree (role_id);


--
-- Name: idx_role_clscope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_role_clscope ON public.client_scope_role_mapping USING btree (role_id);


--
-- Name: idx_scope_mapping_role; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_scope_mapping_role ON public.scope_mapping USING btree (role_id);


--
-- Name: idx_scope_policy_policy; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_scope_policy_policy ON public.scope_policy USING btree (policy_id);


--
-- Name: idx_update_time; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_update_time ON public.migration_model USING btree (update_time);


--
-- Name: idx_us_sess_id_on_cl_sess; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_us_sess_id_on_cl_sess ON public.offline_client_session USING btree (user_session_id);


--
-- Name: idx_usconsent_clscope; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_usconsent_clscope ON public.user_consent_client_scope USING btree (user_consent_id);


--
-- Name: idx_user_attribute; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_attribute ON public.user_attribute USING btree (user_id);


--
-- Name: idx_user_consent; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_consent ON public.user_consent USING btree (user_id);


--
-- Name: idx_user_credential; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_credential ON public.credential USING btree (user_id);


--
-- Name: idx_user_email; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_email ON public.user_entity USING btree (email);


--
-- Name: idx_user_group_mapping; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_group_mapping ON public.user_group_membership USING btree (user_id);


--
-- Name: idx_user_reqactions; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_reqactions ON public.user_required_action USING btree (user_id);


--
-- Name: idx_user_role_mapping; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_user_role_mapping ON public.user_role_mapping USING btree (user_id);


--
-- Name: idx_usr_fed_map_fed_prv; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_usr_fed_map_fed_prv ON public.user_federation_mapper USING btree (federation_provider_id);


--
-- Name: idx_usr_fed_map_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_usr_fed_map_realm ON public.user_federation_mapper USING btree (realm_id);


--
-- Name: idx_usr_fed_prv_realm; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_usr_fed_prv_realm ON public.user_federation_provider USING btree (realm_id);


--
-- Name: idx_web_orig_client; Type: INDEX; Schema: public; Owner: dba
--

CREATE INDEX idx_web_orig_client ON public.web_origins USING btree (client_id);


--
-- Name: client_session_auth_status auth_status_constraint; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_auth_status
    ADD CONSTRAINT auth_status_constraint FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: identity_provider fk2b4ebc52ae5c3b34; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider
    ADD CONSTRAINT fk2b4ebc52ae5c3b34 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_attributes fk3c47c64beacca966; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_attributes
    ADD CONSTRAINT fk3c47c64beacca966 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: federated_identity fk404288b92ef007a6; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.federated_identity
    ADD CONSTRAINT fk404288b92ef007a6 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_node_registrations fk4129723ba992f594; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_node_registrations
    ADD CONSTRAINT fk4129723ba992f594 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: client_session_note fk5edfb00ff51c2736; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_note
    ADD CONSTRAINT fk5edfb00ff51c2736 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: user_session_note fk5edfb00ff51d3472; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_session_note
    ADD CONSTRAINT fk5edfb00ff51d3472 FOREIGN KEY (user_session) REFERENCES public.user_session(id);


--
-- Name: client_session_role fk_11b7sgqw18i532811v7o2dv76; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_role
    ADD CONSTRAINT fk_11b7sgqw18i532811v7o2dv76 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: redirect_uris fk_1burs8pb4ouj97h5wuppahv9f; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.redirect_uris
    ADD CONSTRAINT fk_1burs8pb4ouj97h5wuppahv9f FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: user_federation_provider fk_1fj32f6ptolw2qy60cd8n01e8; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_provider
    ADD CONSTRAINT fk_1fj32f6ptolw2qy60cd8n01e8 FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session_prot_mapper fk_33a8sgqw18i532811v7o2dk89; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session_prot_mapper
    ADD CONSTRAINT fk_33a8sgqw18i532811v7o2dk89 FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: realm_required_credential fk_5hg65lybevavkqfki3kponh9v; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_required_credential
    ADD CONSTRAINT fk_5hg65lybevavkqfki3kponh9v FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_attribute fk_5hrm2vlf9ql5fu022kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu022kqepovbr FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: user_attribute fk_5hrm2vlf9ql5fu043kqepovbr; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_attribute
    ADD CONSTRAINT fk_5hrm2vlf9ql5fu043kqepovbr FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: user_required_action fk_6qj3w1jw9cvafhe19bwsiuvmd; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_required_action
    ADD CONSTRAINT fk_6qj3w1jw9cvafhe19bwsiuvmd FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: keycloak_role fk_6vyqfe4cn4wlq8r6kt5vdsj5c; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.keycloak_role
    ADD CONSTRAINT fk_6vyqfe4cn4wlq8r6kt5vdsj5c FOREIGN KEY (realm) REFERENCES public.realm(id);


--
-- Name: realm_smtp_config fk_70ej8xdxgxd0b9hh6180irr0o; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_smtp_config
    ADD CONSTRAINT fk_70ej8xdxgxd0b9hh6180irr0o FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_attribute fk_8shxd6l3e9atqukacxgpffptw; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_attribute
    ADD CONSTRAINT fk_8shxd6l3e9atqukacxgpffptw FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: composite_role fk_a63wvekftu8jo1pnj81e7mce2; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_a63wvekftu8jo1pnj81e7mce2 FOREIGN KEY (composite) REFERENCES public.keycloak_role(id);


--
-- Name: authentication_execution fk_auth_exec_flow; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_flow FOREIGN KEY (flow_id) REFERENCES public.authentication_flow(id);


--
-- Name: authentication_execution fk_auth_exec_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authentication_execution
    ADD CONSTRAINT fk_auth_exec_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authentication_flow fk_auth_flow_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authentication_flow
    ADD CONSTRAINT fk_auth_flow_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: authenticator_config fk_auth_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.authenticator_config
    ADD CONSTRAINT fk_auth_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: client_session fk_b4ao2vcvat6ukau74wbwtfqo1; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_session
    ADD CONSTRAINT fk_b4ao2vcvat6ukau74wbwtfqo1 FOREIGN KEY (session_id) REFERENCES public.user_session(id);


--
-- Name: user_role_mapping fk_c4fqv34p1mbylloxang7b1q3l; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_role_mapping
    ADD CONSTRAINT fk_c4fqv34p1mbylloxang7b1q3l FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: client_scope_attributes fk_cl_scope_attr_scope; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_attributes
    ADD CONSTRAINT fk_cl_scope_attr_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_scope_role_mapping fk_cl_scope_rm_scope; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_scope_role_mapping
    ADD CONSTRAINT fk_cl_scope_rm_scope FOREIGN KEY (scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_user_session_note fk_cl_usr_ses_note; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_user_session_note
    ADD CONSTRAINT fk_cl_usr_ses_note FOREIGN KEY (client_session) REFERENCES public.client_session(id);


--
-- Name: protocol_mapper fk_cli_scope_mapper; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_cli_scope_mapper FOREIGN KEY (client_scope_id) REFERENCES public.client_scope(id);


--
-- Name: client_initial_access fk_client_init_acc_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.client_initial_access
    ADD CONSTRAINT fk_client_init_acc_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: component_config fk_component_config; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.component_config
    ADD CONSTRAINT fk_component_config FOREIGN KEY (component_id) REFERENCES public.component(id);


--
-- Name: component fk_component_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.component
    ADD CONSTRAINT fk_component_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_default_groups fk_def_groups_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_default_groups
    ADD CONSTRAINT fk_def_groups_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_mapper_config fk_fedmapper_cfg; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_mapper_config
    ADD CONSTRAINT fk_fedmapper_cfg FOREIGN KEY (user_federation_mapper_id) REFERENCES public.user_federation_mapper(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_fedprv; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_fedprv FOREIGN KEY (federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_federation_mapper fk_fedmapperpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_mapper
    ADD CONSTRAINT fk_fedmapperpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: associated_policy fk_frsr5s213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsr5s213xcx4wnkog82ssrfy FOREIGN KEY (associated_policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrasp13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrasp13xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog82sspmt; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82sspmt FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_resource fk_frsrho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_resource
    ADD CONSTRAINT fk_frsrho213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog83sspmt; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog83sspmt FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_server_perm_ticket fk_frsrho213xcx4wnkog84sspmt; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrho213xcx4wnkog84sspmt FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: associated_policy fk_frsrpas14xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.associated_policy
    ADD CONSTRAINT fk_frsrpas14xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: scope_policy fk_frsrpass3xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.scope_policy
    ADD CONSTRAINT fk_frsrpass3xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_perm_ticket fk_frsrpo2128cx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_perm_ticket
    ADD CONSTRAINT fk_frsrpo2128cx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_server_policy fk_frsrpo213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_policy
    ADD CONSTRAINT fk_frsrpo213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: resource_scope fk_frsrpos13xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrpos13xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpos53xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpos53xcx4wnkog82ssrfy FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: resource_policy fk_frsrpp213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_policy
    ADD CONSTRAINT fk_frsrpp213xcx4wnkog82ssrfy FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: resource_scope fk_frsrps213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_scope
    ADD CONSTRAINT fk_frsrps213xcx4wnkog82ssrfy FOREIGN KEY (scope_id) REFERENCES public.resource_server_scope(id);


--
-- Name: resource_server_scope fk_frsrso213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_server_scope
    ADD CONSTRAINT fk_frsrso213xcx4wnkog82ssrfy FOREIGN KEY (resource_server_id) REFERENCES public.resource_server(id);


--
-- Name: composite_role fk_gr7thllb9lu8q4vqa4524jjy8; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.composite_role
    ADD CONSTRAINT fk_gr7thllb9lu8q4vqa4524jjy8 FOREIGN KEY (child_role) REFERENCES public.keycloak_role(id);


--
-- Name: user_consent_client_scope fk_grntcsnt_clsc_usc; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_consent_client_scope
    ADD CONSTRAINT fk_grntcsnt_clsc_usc FOREIGN KEY (user_consent_id) REFERENCES public.user_consent(id);


--
-- Name: user_consent fk_grntcsnt_user; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_consent
    ADD CONSTRAINT fk_grntcsnt_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: group_attribute fk_group_attribute_group; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.group_attribute
    ADD CONSTRAINT fk_group_attribute_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: group_role_mapping fk_group_role_group; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.group_role_mapping
    ADD CONSTRAINT fk_group_role_group FOREIGN KEY (group_id) REFERENCES public.keycloak_group(id);


--
-- Name: realm_enabled_event_types fk_h846o4h0w8epx5nwedrf5y69j; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_enabled_event_types
    ADD CONSTRAINT fk_h846o4h0w8epx5nwedrf5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: realm_events_listeners fk_h846o4h0w8epx5nxev9f5y69j; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_events_listeners
    ADD CONSTRAINT fk_h846o4h0w8epx5nxev9f5y69j FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: identity_provider_mapper fk_idpm_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider_mapper
    ADD CONSTRAINT fk_idpm_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: idp_mapper_config fk_idpmconfig; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.idp_mapper_config
    ADD CONSTRAINT fk_idpmconfig FOREIGN KEY (idp_mapper_id) REFERENCES public.identity_provider_mapper(id);


--
-- Name: web_origins fk_lojpho213xcx4wnkog82ssrfy; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.web_origins
    ADD CONSTRAINT fk_lojpho213xcx4wnkog82ssrfy FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: scope_mapping fk_ouse064plmlr732lxjcn1q5f1; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.scope_mapping
    ADD CONSTRAINT fk_ouse064plmlr732lxjcn1q5f1 FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: protocol_mapper fk_pcm_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.protocol_mapper
    ADD CONSTRAINT fk_pcm_realm FOREIGN KEY (client_id) REFERENCES public.client(id);


--
-- Name: credential fk_pfyr0glasqyl0dei3kl69r6v0; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.credential
    ADD CONSTRAINT fk_pfyr0glasqyl0dei3kl69r6v0 FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: protocol_mapper_config fk_pmconfig; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.protocol_mapper_config
    ADD CONSTRAINT fk_pmconfig FOREIGN KEY (protocol_mapper_id) REFERENCES public.protocol_mapper(id);


--
-- Name: default_client_scope fk_r_def_cli_scope_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.default_client_scope
    ADD CONSTRAINT fk_r_def_cli_scope_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: required_action_provider fk_req_act_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.required_action_provider
    ADD CONSTRAINT fk_req_act_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: resource_uris fk_resource_server_uris; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.resource_uris
    ADD CONSTRAINT fk_resource_server_uris FOREIGN KEY (resource_id) REFERENCES public.resource_server_resource(id);


--
-- Name: role_attribute fk_role_attribute_id; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.role_attribute
    ADD CONSTRAINT fk_role_attribute_id FOREIGN KEY (role_id) REFERENCES public.keycloak_role(id);


--
-- Name: realm_supported_locales fk_supported_locales_realm; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.realm_supported_locales
    ADD CONSTRAINT fk_supported_locales_realm FOREIGN KEY (realm_id) REFERENCES public.realm(id);


--
-- Name: user_federation_config fk_t13hpu1j94r2ebpekr39x5eu5; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_federation_config
    ADD CONSTRAINT fk_t13hpu1j94r2ebpekr39x5eu5 FOREIGN KEY (user_federation_provider_id) REFERENCES public.user_federation_provider(id);


--
-- Name: user_group_membership fk_user_group_user; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.user_group_membership
    ADD CONSTRAINT fk_user_group_user FOREIGN KEY (user_id) REFERENCES public.user_entity(id);


--
-- Name: policy_config fkdc34197cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.policy_config
    ADD CONSTRAINT fkdc34197cf864c4e43 FOREIGN KEY (policy_id) REFERENCES public.resource_server_policy(id);


--
-- Name: identity_provider_config fkdc4897cf864c4e43; Type: FK CONSTRAINT; Schema: public; Owner: dba
--

ALTER TABLE ONLY public.identity_provider_config
    ADD CONSTRAINT fkdc4897cf864c4e43 FOREIGN KEY (identity_provider_id) REFERENCES public.identity_provider(internal_id);


--
-- PostgreSQL database dump complete
--

