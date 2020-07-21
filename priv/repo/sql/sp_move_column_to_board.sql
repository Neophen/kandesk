-- *****************************************************************************
-- Copyright (c) 2020-2020 Sébastien SAINT-SEVIN
-- -----------------------------------------------------------------------------

-- Function: public.sp_move_column_to_board(bigint, bigint)

-- DROP FUNCTION IF EXISTS public.sp_move_column_to_board(bigint, bigint);

CREATE OR REPLACE FUNCTION sp_move_column_to_board(v_column_id bigint, v_board_id bigint)

RETURNS integer AS $$

DECLARE
    v_count integer;
    v_old_board_id bigint;
    v_old_position integer;
    v_last_pos integer;

BEGIN
    select position, board_id into v_old_position, v_old_board_id from columns where id = v_column_id;

    select coalesce(max(position), 0) into v_last_pos from columns where board_id = v_board_id;

    update columns
    set board_id = v_board_id, position = v_last_pos + 1
    where id = v_column_id;

    update columns
    set position = position - 1
    where board_id = v_old_board_id and position > v_old_position;

    GET DIAGNOSTICS v_count = ROW_COUNT;
    RETURN v_count;
END;
$$
LANGUAGE plpgsql;


-- *****************************************************************************
-- END OF FILE
-- -----------------------------------------------------------------------------